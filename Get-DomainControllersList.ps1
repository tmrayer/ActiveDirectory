### Query Active Directory Active User Accounts
## Written by the Cloud Cowboy
## Pop up requests for you to enter information
$Domain = Read-Host 'Enter the FQDN of the Domain you want to query'
$username = Read-Host 'Enter the username in the Domain you want to query'
Get-ADDomainController -Filter * -Server $Domain -Credential (Get-Credential $Domain\$username) | Select Name, ipv4Address, OperatingSystem, site | Sort-Object -Property Name >C:\temp\domainlist\"$domain"DClist.txt 