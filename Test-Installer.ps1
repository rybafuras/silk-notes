[CmdletBinding()]
param([string]$OutputDirectory = (Join-Path $PSScriptRoot 'test-output\installer'))
$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'Build-Installer.ps1')
New-Item -ItemType Directory -Force $OutputDirectory | Out-Null
$resolved = (Resolve-Path -LiteralPath $OutputDirectory).Path
$process = Start-Process -FilePath (Join-Path $PSScriptRoot 'release\SilkNotes-1.3-Setup.exe') -ArgumentList @('--test', ('"' + $resolved + '"')) -WindowStyle Hidden -PassThru
if (!$process.WaitForExit(90000)) { $process.Kill(); throw 'Installer test exceeded 90 seconds.' }
if ($process.ExitCode -ne 0) { Get-Content (Join-Path $resolved 'installer-error.txt') -ErrorAction SilentlyContinue; throw 'Installer test failed.' }
Get-Content (Join-Path $resolved 'installer-test-results.txt')
