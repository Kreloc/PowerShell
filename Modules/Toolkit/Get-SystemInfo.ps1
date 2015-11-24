Function Get-SystemInfo 
{
	<#
	.SYNOPSIS
	This function returns the Name, Domain or Workgroup if not joined to a domain, Model and manufacturer of specified computer(s).
	.DESCRIPTION
	This function returns the Name, Domain or Workgroup if not joined to a domain, Model and manufacturer of specified computer(s) from Win32_ComputerSystem.
	.EXAMPLE
	Get-SystemInfo -ComputerName "THATPC"
	.EXAMPLE
	Get-Content computers.txt | Get-SystemInfo
	.PARAMETERS -ComputerName
	The name of the computer to retrieve information from.
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
		Get-WmiObject Win32_ComputerSystem -ComputerName $ComputerName | Select Name, Domain, Model, Manufacturer
	}
}