Function Get-CPUInfo
{
	<#	
		.SYNOPSIS
			Get-CPUInfo retrieves information about the CPU of the target computer.
		
		.DESCRIPTION
			Get-CPUInfo retrieves information about the CPU of the target computer(s). Leverages the Win32_Processor WMI class.
		
		.PARAMETER ComputerName
			The name of the computer to retrieve information from.
		
		.EXAMPLE
			Get-CPUInfo -ComputerName "THATPC"
			
		.EXAMPLE
			Get-Content computers.txt | Get-CPUInfo
		
		.NOTES
			Helper function for Get-Info.
	#>	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName = $env:computername
	)
	PROCESS 
	{
		Get-WmiObject Win32_Processor -ComputerName $ComputerName | Select Name, NumberofCores, Description, Addresswidth, Manufacturer
	}	
}