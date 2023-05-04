param (
    [string]$Directory = "D:\Projects",
    [string]$Destination = "E:\Transfer\D"
)

$OldFilesJson = Join-Path -Path $Directory -ChildPath "old_files.json"
$OldFiles = Get-Content -Path $OldFilesJson | ConvertFrom-Json

foreach ($File in $OldFiles) {
    $Path = Join-Path -Path $Directory -ChildPath $File.Name
    $ZipFilePath = Join-Path -Path $Directory -ChildPath "$($File.Name).zip"
    
    if (Test-Path $Path -PathType Container) {
        Write-Progress -Activity "Compressing $Path" -Status "Compressing..." -PercentComplete 0
        
        # Compress the directory and update the progress bar
        Compress-Archive -Path $Path -DestinationPath $ZipFilePath -Update -CompressionLevel Optimal `
            -Verbose:$false 
        
        # Move the ZIP file to the destination directory and update the progress bar
        Write-Progress -Activity "Moving $ZipFilePath" -Status "Moving..." -PercentComplete 0
        Move-Item -Path $ZipFilePath -Destination $Destination -Verbose:$false -Force -Confirm:$false `
            -PassThru -ErrorAction Stop | ForEach-Object {
                $PercentComplete = 0
                if ($_.BytesTransferred -gt 0) {
                    $PercentComplete = ($_.BytesTransferred / $_.TotalBytes) * 100
                }
                Write-Progress -Activity "Moving $ZipFilePath" -Status "Moving..." -PercentComplete $PercentComplete
            }
        
        # Rename the original directory with "_backuped" suffix
        $BackupedPath = Join-Path -Path $Directory -ChildPath "$($File.Name)_backuped"
        Rename-Item -Path $Path -NewName $BackupedPath -Verbose:$false -Force
    }
}
