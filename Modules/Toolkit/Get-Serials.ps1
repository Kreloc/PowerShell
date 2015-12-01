Function Get-Serials
{
	<#	
		.SYNOPSIS
			This function retrieves the serial number from the BIOS and the serial number(s) of the monitor(s) attached
			to the target computer.
		
		.DESCRIPTION
			This function retrieves the serial number from the BIOS and the serial number(s) of the monitor(s) attached
			to the target computer. Leverages two WMI Classes, Win32_Bios and WmiMonitorID.
		
		.PARAMETER ComputerName
			The name of the target computer.
		
		.EXAMPLE
			Get-Serials -ComputerName "THATPC"
			
		.EXAMPLE
			Get-Content computers.txt | Get-Serials
		
		.NOTES
			Additional information about the function.
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
		$bios = Get-WmiObject Win32_Bios -ComputerName $ComputerName | Select @{name="PC";expression={$_.__Server}}, SerialNumber, Description
		[array]$monitor = Get-WMIObject WmiMonitorID -Namespace root\wmi -ComputerName $ComputerName
		$numberofmonitors = ($monitor.active.count) -1
		$i = 0
		Do
		{
			[array]$names += ($monitor[$i].UserFriendlyName -NotMatch 0 | ForEach {[char]$_}) -join ""
			$i++
		}
		until($i -gt $numberofmonitors)
		$x = 0
		Do
		{
			[array]$serials += ($monitor[$x].SerialNumberID -NotMatch 0 | ForEach {[char]$_}) -join ""
			$x++
		}
		until($x -gt $numberofmonitors)
	    $props = @{ComputerName=$bios.PC
							PCSerialNumber=$bios.SerialNumber
							MonitorNames=$names
							MonitorSerials=$serials							
		}
		$serials = $null
		$names = $null
		$fininfo = New-Object –TypeName PSObject –Property $props
		$fininfo
	}	
}