# Remote Desktop aktivieren
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
try {
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
} catch {
    Get-NetFirewallRule | Where-Object { $_.Name -like "RemoteDesktop*" } | Enable-NetFirewallRule
}

# Name setzen
Rename-Computer -NewName "Twilight" -Force

# Administrator aktivieren und Passwort setzen
Enable-LocalUser -Name "Administrator"
Get-LocalUser -Name "Administrator"
$SecurePass = Read-Host "Neues Passwort für Administrator" -AsSecureString
Set-LocalUser -Name "Administrator" -Password $SecurePass

# IP-Adresse setzen
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.1.100 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8")
Get-NetAdapter | Select-Object Name, Status

# Hintergrundfarbe setzen
Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name "Background" -Value "0 128 0"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Value "0"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value ""
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters ,1 ,True

# BGInfo herunterladen und starten
$bginfoUrl = "https://download.sysinternals.com/files/BGInfo.zip"
$downloadPath = "$env:TEMP\BGInfo.zip"
$extractPath = "$env:TEMP\BGInfo"
Invoke-WebRequest -Uri $bginfoUrl -OutFile $downloadPath
if (Test-Path $extractPath) { Remove-Item -Path $extractPath -Recurse -Force }
Expand-Archive -Path $downloadPath -DestinationPath $extractPath
Start-Process -FilePath "$extractPath\Bginfo.exe" -ArgumentList "/timer:0 /silent /nolicprompt"
Remove-Item -Path $downloadPath -Force

# Neustart
Restart-Computer -Force
