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
$users = Get-ChildItem "Registry::HKEY_USERS"
foreach ($user in $users) {
    try {
        Set-ItemProperty -Path "Registry::$($user.PSPath)\Control Panel\Colors" -Name "Background" -Value "0 128 0"
        Write-Host "Farbe für $($user.PSChildName) gesetzt."
    } catch {
        Write-Host "Fehler bei $($user.PSChildName): $_"
    }
}
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters ,1 ,True

# BGInfo herunterladen und starten
$bginfoUrl = "https://download.sysinternals.com/files/BGInfo.zip"
$downloadPath = "$env:TEMP\BGInfo.zip"
$extractPath = "$env:TEMP\BGInfo"
Invoke-WebRequest -Uri $bginfoUrl -OutFile $downloadPath
if (Test-Path $extractPath) { Remove-Item -Path $extractPath -Recurse -Force }
try {
    Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force -ErrorAction Stop
    Write-Host "ZIP erfolgreich entpackt."
} catch {
    Write-Host "FEHLER beim Entpacken: $_"
}
$bginfoExe = "$extractPath\Bginfo.exe"
$configPath = "$env:TEMP\Default.bgi"

# Wenn keine Konfig existiert, dann eine generieren (nur nötig beim allerersten Start)
if (!(Test-Path $configPath)) {
    Start-Process -FilePath $bginfoExe -ArgumentList "/nolicprompt" -Wait
    Copy-Item "$env:APPDATA\BGInfo\BGInfo.bgi" $configPath -ErrorAction SilentlyContinue
}

# Jetzt starten mit Profil
Start-Process -FilePath $bginfoExe -ArgumentList "`"$configPath`" /timer:0 /silent /nolicprompt"
Remove-Item -Path $downloadPath -Force

# Neustart
Restart-Computer -Force
