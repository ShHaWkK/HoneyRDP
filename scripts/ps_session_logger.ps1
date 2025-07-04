$logDir = 'C:\Logs'
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$logFile = Join-Path $logDir "session_$timestamp.json"

Start-Transcript -Path (Join-Path $logDir "ps_transcript_$timestamp.txt") -Append

Register-WmiEvent -Class Win32_ProcessStartTrace -Action {
    $proc = $Event.SourceEventArgs.NewEvent
    $entry = [pscustomobject]@{
        time = Get-Date
        command = $proc.ProcessName
        commandLine = $proc.CommandLine
    }
    $entry | ConvertTo-Json -Depth 3 | Out-File -FilePath $logFile -Append
} | Out-Null

while ($true) {
    Start-Sleep -Seconds 5
}

Stop-Transcript
