# Pfad zum übergeordneten Ordner
$Path = "D:\Projects"

# Sammelt alle Ordner im übergeordneten Ordner
$Folders = Get-ChildItem -Path $Path -Directory

# Iteriert durch jeden Ordner und entfernt das Suffix "_backuped"
foreach ($Folder in $Folders) {
    if ($Folder.Name.EndsWith("_backuped")) {
        $NewName = $Folder.Name.Replace("_backuped", "")
        Rename-Item -Path $Folder.FullName -NewName $NewName
        Write-Host "Das Verzeichnis '$($Folder.FullName)' wurde umbenannt."
    }
}

# Bestätigt die Umbenennungen
Write-Host "Alle Umbenennungen wurden erfolgreich durchgeführt."
