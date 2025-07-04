param(
    [string]$OutDir = 'C:\ScreenCaptures'
)
if (-not (Test-Path $OutDir)) {
    New-Item -ItemType Directory -Path $OutDir | Out-Null
}
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$outFile = Join-Path $OutDir "capture_$timestamp.mp4"
$ffmpeg = 'C:\\Program Files\\ffmpeg\\bin\\ffmpeg.exe'
$proc = Start-Process -FilePath $ffmpeg -ArgumentList "-y -f gdigrab -framerate 2 -i desktop -codec:v libx264 -r 2 $outFile" -WindowStyle Hidden -PassThru
# Stop recording when the session ends
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { $proc | Stop-Process } | Out-Null
