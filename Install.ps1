# Configuration
$zipUrl = "https://github.com/pcochet74-dotcom/MineCraft_Cracked_Launcher/releases/download/v1.5.2/MineCraft_Cracked_Launcher.-.v1.5.2.zip"
$destPath = "$env:APPDATA\.minecraft crack"
$zipFile = "$env:TEMP\temp_launcher.zip"
$tempExtract = "$env:TEMP\temp_extract"

# Téléchargement
Write-Host "Téléchargement..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile

# Extraction dans un dossier temporaire
Write-Host "Extraction..." -ForegroundColor Cyan
if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
Expand-Archive -Path $zipFile -DestinationPath $tempExtract -Force

# Déplacer le contenu vers le dossier final
if (-not (Test-Path $destPath)) { New-Item -Path $destPath -ItemType Directory | Out-Null }
Move-Item -Path "$tempExtract\*" -Destination $destPath -Force

# Nettoyage
Remove-Item $zipFile
Remove-Item $tempExtract -Recurse -Force

# Création des raccourcis
$desktop = [Environment]::GetFolderPath("Desktop")
$shell = New-Object -ComObject WScript.Shell

# Raccourci Launcher
$shortcut1 = $shell.CreateShortcut("$desktop\Minecraft Cracked Launcher.lnk")
$shortcut1.TargetPath = "$destPath\MinecraftCrackedLauncher.exe"
$shortcut1.Save()

# Raccourci Mods
$modsPath = "$env:APPDATA\.minecraft\mods"
if (Test-Path $modsPath) {
    $shortcut2 = $shell.CreateShortcut("$desktop\Minecraft Crack Mods.lnk")
    $shortcut2.TargetPath = $modsPath
    $shortcut2.Save()
}

Write-Host "Installation terminée !" -ForegroundColor Green
