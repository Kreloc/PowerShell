Function Get-IPConfig 
{
	<#
	.SYNOPSIS
	Retrieve information on active network connections on computer(s) specified. If only the PCName is returned, it failed to connect to the computer.
	.DESCRIPTION
	Retrieves network adapter information and IP Address settings on computer(s) specified. Leverages Win32_NetworkAdapter and Win32_NetworkAdapterConfiguration. For more info on these two Classes, see
	http://msdn.microsoft.com/en-us/library/aa394216(v=vs.85).aspx
	and
	http://msdn.microsoft.com/en-us/library/aa394217(v=vs.85).aspx
	.EXAMPLE
	Get-IPConfig -ComputerName "THATPC"
	This will retrive the IPAddress, DNSDomain, the hostname, the Default Gateway, the MACAddress, and the IP Subnet set on the active network interface(s) of the computer THATPC.
	.EXAMPLE
	Get-ADComputer * | Select -ExpandProperty Name | Get-IPConfig
	This will retrive the ipconfig information every computer in AD for each active network interface. DO NOT USE THIS EXAMPLE.
	.PARAMETER ComputerName
	The computer name to query
#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName = $env:computername
	)
	PROCESS
	{
		Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $ComputerName  -Filter "IPEnabled = true" | select DNSHostName, DNSDomain, @{name="IPAddress";expression={$_ | Select -ExpandProperty IPAddress}}, @{name="DefaultIPGateway";expression={$_ | Select -ExpandProperty DefaultIPGateway}},@{name="DNSServerSearchOrder";expression={$_.DNSServerSearchOrder -join " , "}}, MacAddress, IPSubnet
	} 
}