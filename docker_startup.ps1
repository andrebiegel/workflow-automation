[CmdletBinding()]
Param(
  [switch]$Remove
)

# Prüfen, ob das Skript als Administrator ausgeführt wird
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  # Prompt anzeigen, um die Ausführung mit Administratorrechten zu bestätigen
  $arguments = "& '" + $MyInvocation.MyCommand.Definition + "' -Remove"
  Start-Process -FilePath PowerShell.exe -Verb RunAs -ArgumentList $arguments
  exit
}

# Pfad zur Docker Desktop-Verknüpfung
$dockerDesktopShortcut = "$([Environment]::GetFolderPath('CommonStartMenu'))\Programs\Docker\Docker Desktop.lnk"

# Prüfen, ob die Verknüpfung existiert
if (-not (Test-Path $dockerDesktopShortcut)) {
  Write-Warning "Die Docker Desktop-Verknüpfung konnte nicht gefunden werden."
  exit
}

if ($Remove) {
  # Registrierungseintrag entfernen
  Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "Docker Desktop" -ErrorAction SilentlyContinue | Out-Null

  Write-Host "Der Registrierungseintrag für Docker Desktop wurde erfolgreich aus dem Startvorgang entfernt."
} else {
  # Prüfen, ob der Registrierungseintrag bereits vorhanden ist
  if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "Docker Desktop" -ErrorAction SilentlyContinue) {
    Write-Warning "Der Registrierungseintrag für Docker Desktop ist bereits im Startvorgang vorhanden."
    exit
  }

  # Registrierungseintrag hinzufügen
  New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "Docker Desktop" -Value "$dockerDesktopShortcut" -PropertyType "String" -Force | Out-Null

  Write-Host "Docker Desktop wurde erfolgreich zum Startvorgang hinzugefügt."
}
