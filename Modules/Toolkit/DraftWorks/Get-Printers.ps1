Function Get-Printers 
{
	<#	
		.SYNOPSIS
			The Get-Printers function returns the printers installed on a computer.
		
		.DESCRIPTION
			The Get-Printers function returns the printers installed on a computer using WMI and the Win32_Printer class.
		
		.PARAMETER ComputerName
			The name of the computer to retrieve installed printers from.
			
		.EXAMPLE
			Get-Printers <ComputerName>
			
			
		.EXAMPLE
			Get-Content computers.txt | Get-Printers
		
		.NOTES
			Scipt made for my work environment. Hence the like "192*"
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName	
	)
	Begin{}
	Process 
	{
		$printers = Get-WmiObject Win32_printer -Computername $ComputerName
		$printers | Where {$_.PortName -like "192*"} | Select Name, PortName
	}
	End{}
}