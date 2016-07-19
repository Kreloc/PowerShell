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
		[string[]]$ComputerName = $env:computername
	)
	Process
	{
        $fininfo = @()
        ForEach($Computer in $ComputerName)
        {
            Try
            {
		        $bios = Get-WmiObject Win32_Bios -ComputerName $Computer -ErrorAction Stop | Select @{name="ComputerName";expression={$_.__Server}}, SerialNumber, Description
            }
            Catch
            {
                Write-Warning "Could not connect to WMI Class Win32_Bios on $Computer"
                Continue
            }
            Try
            {
		        [array]$monitor = Get-WMIObject WmiMonitorID -Namespace root\wmi -ComputerName $Computer -ErrorAction Stop
            }
            Catch
            {
                Write-Warning "Could not connect to WMIMonitorID on $Computer"
                Continue
            }
		    $numberofmonitors = ($monitor.active.count)
		    $i = 0
		    Do
		    {
                If($monitor[$i].UserFriendlyName -notlike "")
                {
			        [array]$names += ($monitor[$i].UserFriendlyName -NotMatch 0 | ForEach {[char]$_}) -join ""
                }
                else
                {
                    [array]$names += ""
                }
			    $i++
		    }
		    until($i -eq $numberofmonitors)
		    $x = 0
		    Do
		    {
                If($monitor[$x].SeialNumberID -notlike "")
                {
			        [array]$serials += ($monitor[$x].SerialNumberID -NotMatch 0 | ForEach {[char]$_}) -join ""
                }
                else
                {
                    [array]$serial += ""
                }
			    $x++
		    }
		    until($x -eq $numberofmonitors)
	        $props = @{ComputerName=$bios.ComputerName
							    PCSerialNumber=$bios.SerialNumber
							    MonitorNames=$names
							    MonitorSerials=$serials							
		    }
		    $serials = $null
		    $names = $null
		    $fininfo += New-Object -TypeName PSObject -Property $props
	    }
        $fininfo
    }
    End{}
}