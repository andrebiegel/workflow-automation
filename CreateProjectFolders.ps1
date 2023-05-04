[CmdletBinding()]
param(
    [Parameter()]
    [string]$projektpfad = $PWD,
    [Parameter(Mandatory=$true)]
    [string]$projektname,
    [switch]$delete,
    [switch]$help,
    [switch]$info
)

if ($help) {
    Get-Help $MyInvocation.MyCommand.Path -Detailed
    return
}



if ($info) {
    Write-Output "Hilfe für das PowerShell-Skript:"
    Write-Output "Verwendung: ./script.ps1 [-projektpfad <pfad>] -projektname <name> [-delete] [-help] [-info]"
    Write-Output ""
    Write-Output "Optionen:"
    Write-Output "  -projektpfad <pfad>  Der Pfad, in dem der Projektordner erstellt werden soll. Standardmäßig ist dies der aktuelle Arbeitsverzeichnispfad."
    Write-Output "  -projektname <name>  Der Name des Projektordners, der erstellt werden soll."
    Write-Output "  -delete              Wenn dieser Schalter angegeben wird, wird der Projektordner gelöscht, wenn er bereits existiert."
    Write-Output "  -help                Zeigt diese Hilfe an."
    Write-Output "  -info                Zeigt Informationen über die verschiedenen Parameter und ihre Verwendung an."
    Write-Output "Beispiel:"
    Write-Output "  ./script.ps1 -projektpfad C:\Projekte -projektname NeuesProjekt -delete"	
    return
}


# Name des Projektordners erstellen
$projektjahr = (Get-Date).Year
$projektordnername = "$projektjahr`_$projektname"

# Projektordnerpfad erstellen
$projektordner = Join-Path -Path $projektpfad -ChildPath $projektordnername

if ($loeschen) {
    # Überprüfen, ob Projektordner vorhanden ist
    if (Test-Path $projektordner) {
        # Projektordner und alle darin enthaltenen Elemente löschen
        Remove-Item -Path $projektordner -Recurse -Force
        Write-Host "Projektordner '$projektordnername' wurde gelöscht."
    } else {
        Write-Warning "Projektordner '$projektordnername' existiert nicht im Pfad '$projektpfad'. Es wurde nichts gelöscht."
    }
} else {
    # Überprüfen, ob Projektordner bereits vorhanden ist
    if (Test-Path $projektordner) {
        Write-Error "Projektordner '$projektordnername' existiert bereits im Pfad '$projektpfad'. Bitte geben Sie einen anderen Projektnamen an oder löschen Sie den vorhandenen Projektordner."
        return
    }

    # Projektordner erstellen, wenn er noch nicht vorhanden ist
    New-Item -ItemType Directory -Path $projektordner

    # Unterordner für Code, Anforderungen, Zugänge und Systeme erstellen
    $codeordner = Join-Path -Path $projektordner -ChildPath "Code"
    $anforderungenordner = Join-Path -Path $projektordner -ChildPath "Anforderungen"
    $zugangsordner = Join-Path -Path $projektordner -ChildPath "Zugänge"
    $systemeordner = Join-Path -Path $projektordner -ChildPath "Systeme"
	$DBWeaver = Join-Path -Path $projektordner -ChildPath "db-weaver"

    New-Item -ItemType Directory -Path $codeordner
    New-Item -ItemType Directory -Path $anforderungenordner
    New-Item -ItemType Directory -Path $zugangsordner
    New-Item -ItemType Directory -Path $systemeordner
	New-Item -ItemType Directory -Path $DBWeaver
	
	
	# Pfad zum Skript
	$skriptPfad = ".\dbweaver_download.ps1"

	# Zielpfad erstellen
	$zvPfad = Join-Path -Path $DBWeaver

	# ZV-Parameter definieren
	$zvParameter = "-Zielverzeichnis '$zvPfad'"

	# Skript ausführen
	Invoke-Command -ScriptBlock { & $using:skriptPfad $using:zvParameter }
}

