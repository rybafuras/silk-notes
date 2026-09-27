[CmdletBinding()]
param([string]$OutputDirectory = (Join-Path $PSScriptRoot 'release'))
$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'Source\Build.ps1')
New-Item -ItemType Directory -Force $OutputDirectory,(Join-Path $PSScriptRoot 'artifacts') | Out-Null
$framework = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319'
if (!(Test-Path $framework)) { $framework = Join-Path $env:WINDIR 'Microsoft.NET\Framework\v4.0.30319' }
$payload = Join-Path $PSScriptRoot 'artifacts\payload.zip'
Add-Type -AssemblyName System.IO.Compression.FileSystem
# FileMode.Create truncates only this generated archive; no directory deletion.
$payloadStream = [System.IO.File]::Open($payload,[System.IO.FileMode]::Create)
$archive = [System.IO.Compression.ZipArchive]::new($payloadStream,[System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($name in @('Silk Notes.exe','Silk Notes.exe.config')) {
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive,(Join-Path $PSScriptRoot "bin\$name"),$name) | Out-Null
    }
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive,(Join-Path $PSScriptRoot 'LICENSE'),'LICENSE.txt') | Out-Null
} finally { $archive.Dispose(); $payloadStream.Dispose() }
$refs = @('System.dll','System.Core.dll','System.Xaml.dll','System.IO.Compression.dll','System.IO.Compression.FileSystem.dll','WPF\WindowsBase.dll','WPF\PresentationCore.dll','WPF\PresentationFramework.dll') | ForEach-Object { '/reference:' + (Join-Path $framework $_) }
$output = Join-Path $OutputDirectory 'SilkNotes-1.3-Setup.exe'
& (Join-Path $framework 'csc.exe') /nologo /target:winexe /platform:anycpu /optimize+ "/out:$output" "/win32manifest:$PSScriptRoot\Source\app.manifest" "/win32icon:$PSScriptRoot\Source\Assets\Silk.ico" "/resource:$payload,SilkNotes.Payload.zip" "/resource:$PSScriptRoot\Source\Assets\logo.png,SilkNotes.Logo.png" "/resource:$PSScriptRoot\Source\Theme.xaml,SilkNotes.Theme.xaml" $refs "$PSScriptRoot\Installer\Setup.cs" "$PSScriptRoot\Source\Appearance.cs" "$PSScriptRoot\Source\Localization.cs" "$PSScriptRoot\Source\WindowDesign.cs" "$PSScriptRoot\Source\AssemblyInfo.cs"
if($LASTEXITCODE -ne 0) { throw 'Installer build failed' }
Write-Output "Built $output"
