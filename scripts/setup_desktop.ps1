$wallpaper = 'C:\HoneypotScripts\wallpaper.jpg'
$wallpaperB64 = 'C:\HoneypotScripts\wallpaper.b64'
$desktop = [Environment]::GetFolderPath('Desktop')

function Set-Wallpaper {
    param([string]$Path)
    Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
  [DllImport("user32.dll",SetLastError=true)]
  public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
    $SPI_SETDESKWALLPAPER = 20
    $SPIF_UPDATEINIFILE = 0x1
    $SPIF_SENDCHANGE    = 0x2
    [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER,0,$Path,$SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE) | Out-Null
}

if (Test-Path $wallpaperB64 -and -not (Test-Path $wallpaper)) {
    $bytes = [System.Convert]::FromBase64String((Get-Content $wallpaperB64 -Raw))
    [System.IO.File]::WriteAllBytes($wallpaper, $bytes) | Out-Null
}

if (Test-Path $wallpaper) { Set-Wallpaper -Path $wallpaper }

# Fake folders
$dirs = @('C:\Projects','C:\Docs','C:\Tools')
foreach ($d in $dirs) { if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d | Out-Null } }

# Create lure shortcuts on desktop
$shell = New-Object -ComObject WScript.Shell
$src = 'C:\ImportantData'
Get-ChildItem $src -File | ForEach-Object {
    $shortcut = $shell.CreateShortcut((Join-Path $desktop ($_.Name + '.lnk')))
    $shortcut.TargetPath = $_.FullName
    $shortcut.Save()
}
