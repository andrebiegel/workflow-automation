# Konfigurationsparameter
$logDir = "C:\pfad\zu\den\logs"
$daysToKeep = 7

# Berechne das Datum vor x Tagen
$cutOffDate = (Get-Date).AddDays(-$daysToKeep)

# Lösche Dateien, die älter als die festgelegte Anzahl von Tagen sind
Get-ChildItem -Path $logDir -Recurse | Where-Object { $_.LastWriteTime -lt $cutOffDate } | Remove-Item -Force