Function Get-UpTime 
{
	<#
	.SYNOPSIS
	Get-UpTime determines how long a computer has been up and running.
	
	.DESCRIPTION
	Get-UpTime determines how long a computer has been up and running. Uses the Win32_OperatingSystem WMI Class.
	
	.PARAMETER ComputerName
	The name of the computer to find uptime on. If not used, uptime will be determined for computer runnning the function.
	
	.EXAMPLE
	Get-UpTime
	
	Outputs how long the current computer has been on.
	
	.EXAMPLE
	Import-CSV .\Computers.csv | Get-UpTime
	
	Finds the uptime for each computer under the heading ComputerName.
	
	#>
	[CmdletBinding()]
	param
	(
	[Parameter(Mandatory=$False,
	ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
	[alias("Device Name")]
	[string]$ComputerName = $env:COMPUTERNAME
	)
	Begin{}
	Process 
	{
		$Date = Get-Date
		$OS = Get-WMIObject -Class Win32_OperatingSystem -ComputerName $ComputerName
		$Date - ($os.ConvertToDateTime($os.LastBootUpTime)) | Select @{Name="ComputerName";Expression={"$ComputerName"}}, Days, Hours, Minutes, Seconds, @{Name="Date";Expression={$Date.ToString("M/d/yyyy")}}
		}
	End{}
}