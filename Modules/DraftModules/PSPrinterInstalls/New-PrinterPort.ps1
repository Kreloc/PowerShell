Function New-PrinterPort 
{
	<#	
		.SYNOPSIS
			A brief description of the Get-Blank function.
		
		.DESCRIPTION
			A detailed description of the Get-Blank function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			Get-Blank <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Get-Blank
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName")]
		[string]$ComputerName = $env:computername,
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("IP","Address")]
		[string]$PrinterIP,
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("Port")]
		[string]$PrinterPort = "TCP/IP",						
	)
param ($PrinterIP, $PrinterPort, $PrinterPortName, $ComputerName)
$wmi = [wmiclass]"\\$ComputerName\root\cimv2:win32_tcpipPrinterPort"
$wmi.psbase.scope.options.enablePrivileges = $true
$Port = $wmi.createInstance()
$Port.name = $PrinterPortName
$Port.hostAddress = $PrinterIP
$Port.portNumber = $PrinterPort
$Port.SNMPEnabled = $false
$Port.Protocol = 1
$Port.put()
}