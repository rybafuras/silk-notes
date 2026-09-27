[CmdletBinding()]
param([string]$OutputDirectory = (Join-Path $PSScriptRoot 'test-output'))
$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'Source\Build.ps1')
New-Item -ItemType Directory -Force $OutputDirectory | Out-Null
$resolvedOutput = (Resolve-Path -LiteralPath $OutputDirectory).Path
# The test app uses a separate data folder and never opens the user's actual notes.
$process = Start-Process -FilePath (Join-Path $PSScriptRoot 'bin\Silk Notes.exe') -ArgumentList @('--test', ('"' + $resolvedOutput + '"')) -WindowStyle Hidden -PassThru
if (!$process.WaitForExit(60000)) { $process.Kill(); throw 'Test run exceeded 60 seconds.' }
if ($process.ExitCode -ne 0) {
    $errorFile = Join-Path $resolvedOutput 'test-error.txt'
    if (Test-Path -LiteralPath $errorFile) { Get-Content -LiteralPath $errorFile }
    throw "Tests failed with exit code $($process.ExitCode)"
}
Get-Content -LiteralPath (Join-Path $resolvedOutput 'test-results.txt'), (Join-Path $resolvedOutput 'window-test-results.txt'), (Join-Path $resolvedOutput 'release-test-results.txt'), (Join-Path $resolvedOutput 'personalization-test-results.txt')
