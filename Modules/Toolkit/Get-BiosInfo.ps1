Function Get-BiosInfo 
{
<#
	.SYNOPSIS
		This function returns the serial number and description of the BIOS on the computer(s) specified.
	.DESCRIPTION
		This function returns the serial number and description of the BIOS on the computer(s) specified. Leverages the Win32_BIOS WMI Class. 
	.EXAMPLE
		Get-BiosInfo -ComputerName "THATPC"
	.EXAMPLE
		Get-Content computers.txt | Get-BiosInfo 
	.PARAMETER ComputerName
		The name of the computer to retrieve serial number and description from.
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
		Get-WmiObject Win32_Bios -ComputerName $ComputerName | Select @{name="PC";expression={$_.__Server}}, SerialNumber, Description
	}
}