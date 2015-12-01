Function Get-ServiceDetails($ComputerName)
{
	If(-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
		"Please re-run this as administrator."
		exit
	}
	else
	{
		Get-WMIObject -Class Win32_Service -ComputerName $ComputerName | Select __Server, Name, Startmode, State, StartName |
		ForEach-Object {$_ | Select *}
	}

}
Get-ServiceDetails -ComputerName "localhost" | Out-File ".\$($__Server)Services.csv" -NoClobber -Append
#Failed to implement the impersonate remote user.