#OSDCloud script that was modified by me to allow for contactless windows installation. This is hosted on https://gist.githubusercontent.com/DannyAlba/edd853da6743c896640a5329d938c618/raw/d6a679a3368faabca519c4da903357e957a4b81e/osdcloud_config.ps1

Write-Host -ForegroundColor Green "Starting OSDCloud ZTI"
Start-Sleep -Seconds 5

# Start the OSDCloud process to install Windows 11 24H2 Pro
Start-OSDCloud -OSVersion 'Windows 11' -OSBuild 24H2 -OSEdition Pro -OSLanguage en-us -OSLicense Retail -ZTI

# Try to find the USB drive labeled either "OSDCloud" or "OSDCloudUSB"
$USBPath = (Get-Volume | Where-Object { $_.FileSystemLabel -eq "OSDCloud" -or $_.FileSystemLabel -eq "OSDCloudUSB" } | Select-Object -ExpandProperty DriveLetter -ErrorAction SilentlyContinue)

if ($USBPath) {
    Write-Host "Found USB drive at $USBPath with label OSDCloud or OSDCloudUSB."
} else {
    Write-Host "No USB drive found with label OSDCloud or OSDCloudUSB."
    exit 1
}

# Check if the PPKG exists on the USB drive
$ppkgPath = "$($USBPath):\NinjaOne_Config.ppkg"
if (Test-Path $ppkgPath) {
    Write-Host "Applying Provisioning Package from: $ppkgPath"

    # Apply the PPKG using DISM with Start-Process to ensure correct argument passing in PowerShell
    Start-Process -FilePath "dism.exe" -ArgumentList "/Online /Add-ProvisioningPackage /PackagePath:`"$ppkgPath`" /Quiet /NoRestart" -Wait -NoNewWindow

    # Check if DISM command was successful
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Provisioning Package applied successfully."
    } else {
        Write-Host "Failed to apply Provisioning Package. DISM exited with code $LASTEXITCODE." -ForegroundColor Red
    }
} else {
    Write-Host "PPKG not found. Skipping application."
}

#Restart from WinPE
Write-Host -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20

wpeutil rebo
