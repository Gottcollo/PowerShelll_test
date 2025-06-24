$pwd = Read-Host "Enter the SafeModeAdminPassword" -AsSecureString
Install-ADDSForest `
-DomainName sonne.local -DomainNetBiosName SONNE `
-DomainMode WinThreshold -ForestMode WinThreshold `
-SkipPreChecks `
-InstallDns:$true `
-SafeModeAdministratorPassword $pwd `
-Force


	
Add-DnsServerPrimaryZone -NetworkID 192.168.178.0/24 -ReplicationScope Domain -DynamicUpdate Secure -PassThru

Set-DnsClientServerAddress -InterfaceAlias "LAN" -ServerAddresses 192.168.178.200

Set-DnsServerForwarder -IPAddress 192.168.178.1, 8.8.8.8
