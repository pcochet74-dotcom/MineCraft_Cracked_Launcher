# Création du script PowerShell (.ps1) pour automatiser les tâches demandées.

ps1_content = r'''
# Configuration
$zipUrl = "https://github.com/pcochet74-dotcom/MineCraft_Cracked_Launcher/releases/download/v1.5.2/MineCraft_Cracked_Launcher.-.v1.5.2.zip"
$extractPath = "$env:APPDATA\.minecraft crack"
$zipFile = "$env:TEMP\temp_launcher.zip"

# Création du dossier cible
if (-not (Test-Path $extractPath)) {
    New-Item -Path $extractPath -ItemType Directory | Out-Null
}

# Téléchargement
Write-Host "Téléchargement en cours..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile

# Extraction
Write-Host "Extraction..." -ForegroundColor Cyan
Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force

# Suppression du zip temporaire
Remove-Item $zipFile

# Création des raccourcis sur le bureau
$desktop = [Environment]::GetFolderPath("Desktop")
$shell = New-Object -ComObject WScript.Shell

# Raccourci 1: MinecraftCrackedLauncher.exe
$target1 = "$extractPath\MinecraftCrackedLauncher.exe"
$shortcut1 = $shell.CreateShortcut("$desktop\Minecraft Cracked Launcher.lnk")
$shortcut1.TargetPath = $target1
$shortcut1.Save()

# Raccourci 2: %APPDATA%\.minecraft\mods
$target2 = "$env:APPDATA\.minecraft\mods"
if (Test-Path $target2) {
    $shortcut2 = $shell.CreateShortcut("$desktop\Dossier Mods.lnk")
    $shortcut2.TargetPath = $target2
    $shortcut2.Save()
} else {
    Write-Host "Le dossier mods n'existe pas, impossible de créer le raccourci." -ForegroundColor Yellow
}

Write-Host "Installation terminée avec succès !" -ForegroundColor Green
'''

# Sauvegarde du script
with open("installer.ps1", "w", encoding="utf-8") as f:
    f.write(ps1_content)

print("Script PowerShell généré : installer.ps1