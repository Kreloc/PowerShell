Function Get-LastUser
{
	<#	
		.SYNOPSIS
			Get-LastUser retrieves the user name of the last user to log on to a computer.
		
		.DESCRIPTION
			Get-LastUser retrieves the user name of the last user to log on to a computer using WMI and the Win32_UserProfile class.
		
		.PARAMETER ComputerName
			The name of the computer to find the last user to have logged on to it.
		
		.EXAMPLE
			PS C:\> Get-LastUser -Computer "THATPC"
			
		.EXAMPLE
			Get-Content computers.txt | Get-LastUser
		
		.NOTES
			Written in an attempt to find the last user that loggen on before running backups.
	#>	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName	
	)
	Begin
	{
		$WQLFilter = "NOT SID = 'S-1-5-18' AND NOT SID = 'S-1-5-19' AND NOT SID = 'S-1-5-20'"	
	}
	Process
	{
		$Win32User = Get-WmiObject -Class Win32_UserProfile -Filter $WQLFilter -ComputerName $ComputerName
		$LastUser = $Win32User | Sort-Object -Property LastUseTime -Descending | Select-Object -First 1
		$Loaded = $LastUser.Loaded
		$Time = ([WMI]'').ConvertToDateTime($LastUser.LastUseTime)						
		#Convert SID to Account for friendly display
		$UserSID = New-Object System.Security.Principal.SecurityIdentifier($LastUser.SID)
		$User = $UserSID.Translate([System.Security.Principal.NTAccount])
		$userName = ($user -split '\\')[1]
		$userName		
	}	
	End{}
}