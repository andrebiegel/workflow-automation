param (
    [string]$Directory = "D:\Projects"
)

$CutOffDate = (Get-Date).AddYears(-2)

$Files = Get-ChildItem -Path $Directory -Directory | 
         Where-Object {$_.LastWriteTime -lt $CutOffDate} | 
         Select-Object Name, LastWriteTime, @{n="Length";e={$_.PSIsContainer}}

$OutputFilePath = Join-Path -Path $Directory -ChildPath "old_files.json"
$Files | ConvertTo-Json | Out-File -FilePath $OutputFilePath
