# Configuration
$zipUrl = "https://github.com/pcochet74-dotcom/MineCraft_Cracked_Launcher/releases/download/v1.5.2/MineCraft_Cracked_Launcher.-.v1.5.2.zip"
$modsZipUrl = "https://github.com/pcochet74-dotcom/MineCraft_Cracked_Launcher/releases/download/Mods/Mods.zip"
$cmdUrl = "https://github.com/pcochet74-dotcom/MineCraft_Cracked_Launcher/releases/download/v1.5.2/Install.cmd"

$destPath = "$env:APPDATA\.minecraft crack"
$modsPath = "$env:APPDATA\.minecraft\mods"
$zipFile = "$env:TEMP\temp_launcher.zip"
$tempExtract = "$env:TEMP\temp_extract"

function Show-Menu {
    Clear-Host
    Write-Host "=== Menu d'installation ===" -ForegroundColor Yellow
    Write-Host "1. Installer le Launcher"
    Write-Host "2. Créer les raccourcis sur le bureau"
    Write-Host "3. Installer les Mods"
    Write-Host "4. Installer le fichier de config (Install.cmd)"
    Write-Host "5. Quitter"
    return Read-Host "Faites votre choix (1-5)"
}

do {
    $choice = Show-Menu
    switch ($choice) {
        '1' {
            Write-Host "Téléchargement du Launcher..." -ForegroundColor Cyan
            try {
                Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
                if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
                Expand-Archive -Path $zipFile -DestinationPath $tempExtract -Force
                
                $sourceDir = Join-Path $tempExtract "Minecraft"
                if (-not (Test-Path $destPath)) { New-Item -Path $destPath -ItemType Directory | Out-Null }
                
                if (Test-Path $sourceDir) {
                    Move-Item -Path "$sourceDir\*" -Destination $destPath -Force
                    Write-Host "Installation du launcher terminée !" -ForegroundColor Green
                } else {
                    Write-Host "Erreur : Le dossier 'Minecraft' est introuvable." -ForegroundColor Red
                }
                Remove-Item $zipFile -Force
                Remove-Item $tempExtract -Recurse -Force
            } catch { Write-Host "Erreur : $($_.Exception.Message)" -ForegroundColor Red }
            Pause
        }
        '2' {
            $desktop = [Environment]::GetFolderPath("Desktop")
            $shell = New-Object -ComObject WScript.Shell
            $exePath = "$destPath\MinecraftCrackedLauncher.exe"
            
            if (Test-Path $exePath) {
                $shortcut1 = $shell.CreateShortcut("$desktop\Minecraft Cracked Launcher.lnk")
                $shortcut1.TargetPath = $exePath
                $shortcut1.Save()
                Write-Host "Raccourci du launcher créé." -ForegroundColor Green
            }
            if (Test-Path $modsPath) {
                $shortcut2 = $shell.CreateShortcut("$desktop\Dossier Mods.lnk")
                $shortcut2.TargetPath = $modsPath
                $shortcut2.Save()
                Write-Host "Raccourci du dossier Mods créé." -ForegroundColor Green
            }
            $cmdPath = "$destPath\Install.cmd"
            if (Test-Path $cmdPath) {
                $shortcut3 = $shell.CreateShortcut("$desktop\Install Config.lnk")
                $shortcut3.TargetPath = $cmdPath
                $shortcut3.Save()
                Write-Host "Raccourci de Install.cmd créé." -ForegroundColor Green
            }
            Pause
        }
        '3' {
            Write-Host "Téléchargement des Mods..." -ForegroundColor Cyan
            try {
                if (-not (Test-Path $modsPath)) { New-Item -Path $modsPath -ItemType Directory -Force | Out-Null }
                Invoke-WebRequest -Uri $modsZipUrl -OutFile $zipFile
                Expand-Archive -Path $zipFile -DestinationPath $modsPath -Force
                Remove-Item $zipFile -Force
                Write-Host "Mods installés." -ForegroundColor Green
            } catch { Write-Host "Erreur lors de l'installation des mods." -ForegroundColor Red }
            Pause
        }
        '4' {
            Write-Host "Téléchargement de Install.cmd..." -ForegroundColor Cyan
            try {
                if (-not (Test-Path $destPath)) { New-Item -Path $destPath -ItemType Directory -Force | Out-Null }
                Invoke-WebRequest -Uri $cmdUrl -OutFile "$destPath\Install.cmd"
                Write-Host "Install.cmd copié dans $destPath" -ForegroundColor Green
            } catch { Write-Host "Erreur lors du téléchargement." -ForegroundColor Red }
            Pause
        }
    }
} while ($choice -ne '5')
