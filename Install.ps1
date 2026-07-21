# Configuration
$zipUrl = "https://github.com/pcochet74-dotcom/MineCraft_Cracked_Launcher/releases/download/v1.5.2/MineCraft_Cracked_Launcher.-.v1.5.2.zip"
$modsServ1Url = "https://github.com/pcochet74-dotcom/MineCraft_Cracked_Launcher/releases/download/Mods/Mods_Serv1.zip" # Remplace par l'URL du premier serveur
$modsServ2Url = "https://github.com/pcochet74-dotcom/MineCraft_Cracked_Launcher/releases/download/Mods/Mods_Serv2.zip" # Remplace par l'URL du second serveur
$cmdUrl = "https://github.com/pcochet74-dotcom/MineCraft_Cracked_Launcher/releases/download/v1.5.2/Install.cmd"

$destPath = "$env:APPDATA\.minecraft crack"
$modsPath = "$env:APPDATA\.minecraft\mods"
$zipFile = "$env:TEMP\temp_launcher.zip"
$tempExtract = "$env:TEMP\temp_extract"

function Show-Menu {
    Clear-Host
    Write-Host "=== Menu d'installation ===" -ForegroundColor Yellow
    Write-Host "1. Installer le Launcher"
    Write-Host "2. Installer le fichier de config (Install.cmd)"
    Write-Host "3. Installer les Mods"
    Write-Host "4. Créer les raccourcis sur le bureau"
    Write-Host "5. Quitter"
    return Read-Host "Faites votre choix (1-5)"
}

function Show-ModsMenu {
    Clear-Host
    Write-Host "=== Menu Mods ===" -ForegroundColor Yellow
    Write-Host "1. Installer les mods pour le Serveur 1"
    Write-Host "2. Installer les mods pour le Serveur 2"
    Write-Host "3. Retour au menu principal"
    return Read-Host "Faites votre choix (1-3)"
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
            Write-Host "Téléchargement de Install.cmd..." -ForegroundColor Cyan
            try {
                if (-not (Test-Path $destPath)) { New-Item -Path $destPath -ItemType Directory -Force | Out-Null }
                Invoke-WebRequest -Uri $cmdUrl -OutFile "$destPath\Install.cmd"
                Write-Host "Install.cmd copié dans $destPath" -ForegroundColor Green
            } catch { Write-Host "Erreur lors du téléchargement." -ForegroundColor Red }
            Pause
        }
        '3' {
            do {
                $modsChoice = Show-ModsMenu
                switch ($modsChoice) {
                    '1' {
                        Write-Host "Téléchargement des mods du Serveur 1..." -ForegroundColor Cyan
                        try {
                            if (-not (Test-Path $modsPath)) { New-Item -Path $modsPath -ItemType Directory -Force | Out-Null }
                            Invoke-WebRequest -Uri $modsServ1Url -OutFile $zipFile
                            Expand-Archive -Path $zipFile -DestinationPath $modsPath -Force
                            Remove-Item $zipFile -Force
                            Write-Host "Mods du Serveur 1 installés." -ForegroundColor Green
                        } catch { Write-Host "Erreur lors de l'installation des mods du Serveur 1." -ForegroundColor Red }
                        Pause
                    }
                    '2' {
                        Write-Host "Téléchargement des mods du Serveur 2..." -ForegroundColor Cyan
                        try {
                            if (-not (Test-Path $modsPath)) { New-Item -Path $modsPath -ItemType Directory -Force | Out-Null }
                            Invoke-WebRequest -Uri $modsServ2Url -OutFile $zipFile
                            Expand-Archive -Path $zipFile -DestinationPath $modsPath -Force
                            Remove-Item $zipFile -Force
                            Write-Host "Mods du Serveur 2 installés." -ForegroundColor Green
                        } catch { Write-Host "Erreur lors de l'installation des mods du Serveur 2." -ForegroundColor Red }
                        Pause
                    }
                }
            } while ($modsChoice -ne '3')
        }
        '4' {
            $desktop = [Environment]::GetFolderPath("Desktop")
            $shell = New-Object -ComObject WScript.Shell
            
            $exePath = "$destPath\MinecraftCrackedLauncher.exe"
            if (Test-Path $exePath) {
                $s1 = $shell.CreateShortcut("$desktop\Minecraft Cracked Launcher.lnk")
                $s1.TargetPath = $exePath
                $s1.Save()
                Write-Host "Raccourci du launcher créé." -ForegroundColor Green
            }
            
            if (Test-Path $modsPath) {
                $s2 = $shell.CreateShortcut("$desktop\Dossier Mods.lnk")
                $s2.TargetPath = $modsPath
                $s2.Save()
                Write-Host "Raccourci du dossier Mods créé." -ForegroundColor Green
            }
            
            $cmdPath = "$destPath\Install.cmd"
            if (Test-Path $cmdPath) {
                $s3 = $shell.CreateShortcut("$desktop\config.cmd.lnk")
                $s3.TargetPath = $cmdPath
                $s3.Save()
                Write-Host "Raccourci 'config.cmd' créé sur le bureau." -ForegroundColor Green
            }
            Pause
        }
    }
} while ($choice -ne '5')
