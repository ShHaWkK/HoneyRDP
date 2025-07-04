$source = 'C:\ImportantData'
$template = 'C:\LureTemplates'
if (-not (Test-Path $template)) { return }
Get-ChildItem $source -File | Remove-Item -Force
Copy-Item -Path "$template\*" -Destination $source -Recurse
