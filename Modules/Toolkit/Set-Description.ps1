Function Set-Description
{
	<#	
		.SYNOPSIS
			Set-Description populates the description field on the computer specified.
		
		.DESCRIPTION
			Set-Description populates the description field on the computer specified. Uses the Win32_OperatingSystem WMI Class.
		
		.PARAMETER ComputerName
			The name of the computer the description is to be set on.
			
		.PARAMETER Description
			The the description of the target computer.			
		
		.EXAMPLE
			Set-Description -ComputerName "THATPC" -Description "This PC - Person - Office"
			
		.EXAMPLE
			Import-CSV computerdescriptions.csv | Set-Description
			Where computerdescriptions.csv has ComputerName, Description as the headers.
		
		.NOTES
			Additional information about the function.
	#>	
	[CmdletBinding()]
	Param
	(
	[Parameter(Mandatory=$True,Position=0)][Alias('Name')]
	[string]$ComputerName,	
	[Parameter(Mandatory=$True, Position=1)]
	[string]$Description
	)
	PROCESS
	{
			$OSValues = Get-WmiObject -class Win32_OperatingSystem -computerName $ComputerName		
			$OSValues.Description = "$Description"
			$OSValues.put() | Out-Null
	}
}