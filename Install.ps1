# Configuration
$zipUrl = "https://github.com/pcochet74-dotcom/MineCraft_Cracked_Launcher/releases/download/v1.5.2/MineCraft_Cracked_Launcher.-.v1.5.2.zip"
$destPath = "$env:APPDATA\.minecraft crack"
$zipFile = "$env:TEMP\temp_launcher.zip"
$tempExtract = "$env:TEMP\temp_extract"

function Show-Menu {
    Clear-Host
    Write-Host "=== Menu d'installation ===" -ForegroundColor Yellow
    Write-Host "1. Installer le Launcher"
    Write-Host "2. Créer les raccourcis sur le bureau"
    Write-Host "3. Quitter"
    return Read-Host "Faites votre choix (1-3)"
}

do {
    $choice = Show-Menu
    switch ($choice) {
        '1' {
            Write-Host "Téléchargement..." -ForegroundColor Cyan
            try {
                Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
                
                if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
                Expand-Archive -Path $zipFile -DestinationPath $tempExtract -Force
                
                # Gestion du sous-dossier renommé 'Minecraft'
                $sourceDir = Join-Path $tempExtract "Minecraft"
                
                if (-not (Test-Path $destPath)) { New-Item -Path $destPath -ItemType Directory | Out-Null }
                
                if (Test-Path $sourceDir) {
                    Move-Item -Path "$sourceDir\*" -Destination $destPath -Force
                    Write-Host "Installation terminée !" -ForegroundColor Green
                } else {
                    Write-Host "Erreur : Le dossier 'Minecraft' est introuvable dans le ZIP." -ForegroundColor Red
                }
                
                Remove-Item $zipFile -Force
                Remove-Item $tempExtract -Recurse -Force
            } catch {
                Write-Host "Erreur : $($_.Exception.Message)" -ForegroundColor Red
            }
            Pause
        }
        '2' {
            $desktop = [Environment]::GetFolderPath("Desktop")
            $shell = New-Object -ComObject WScript.Shell
            
            # Raccourci Launcher
            $exePath = "$destPath\MinecraftCrackedLauncher.exe"
            if (Test-Path $exePath) {
                $shortcut1 = $shell.CreateShortcut("$desktop\Minecraft Cracked Launcher.lnk")
                $shortcut1.TargetPath = $exePath
                $shortcut1.Save()
                Write-Host "Raccourci du launcher créé." -ForegroundColor Green
            } else {
                Write-Host "Erreur : Le fichier .exe est introuvable. Installez le launcher d'abord." -ForegroundColor Red
            }

            # Raccourci Mods
            $modsPath = "$env:APPDATA\.minecraft\mods"
            if (Test-Path $modsPath) {
                $shortcut2 = $shell.CreateShortcut("$desktop\Dossier Mods.lnk")
                $shortcut2.TargetPath = $modsPath
                $shortcut2.Save()
                Write-Host "Raccourci du dossier Mods créé." -ForegroundColor Green
            } else {
                Write-Host "Note : Le dossier .minecraft\mods n'existe pas." -ForegroundColor Yellow
            }
            Pause
        }
    }
} while ($choice -ne '3')
