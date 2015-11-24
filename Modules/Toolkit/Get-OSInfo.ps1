Function Get-OSInfo 
{
<#
.SYNOPSIS
	This function returns the Name of the OS, the OS Version, OS Architechture (32-bit or 64-bit), Last Boot Up Time, and Free RAM of specified computer(s).
.DESCRIPTION
	This function returns the Name of the OS, the OS Version, OS Architechture (32-bit or 64-bit), Last Boot Up Time, and Free RAM of specified computer(s) from Win32_OperatingSystem.
.EXAMPLE
	Get-OSInfo Family
.EXAMPLE
	List of computers | Get-OSInfo
.PARAMETER ComputerName
	The name of the computer the information is to be retrieved from.
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
			Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName | Select Caption, Version, Description, OSArchitecture, FreePhysicalMemory , @{name="PC";expression={$_.__Server}}, @{name="LastBootUpTime";expression={$_.ConvertToDateTime($_.LastBootUpTime)}}
	}
}