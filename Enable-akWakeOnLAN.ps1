Function Enable-akWakeOnLAN
{
	<#	
		.SYNOPSIS
			Enables WakeOnLAN on specified computer.
		
		.DESCRIPTION
			Enables WakeOnLAN on specified computer. Uses three WMI Classes.
		
		.PARAMETER ComputerName
			The name of the computer to enable for WakeOnLAN.
		
		.EXAMPLE
			Enable-akWakeOnLAN <ComputerName>
			
			Enable WakeOnLAN on specified computer. Returns an object with computername and boolean for WakeOnLANEnabled.

        .EXAMPLE
            Enable-akWakeOnLAN -EnableSavePower

            Enables WakeOnLAN on specified computer for active NIC. Also sets that NIC to be Allow this device to turn off this computer to save power to enabled.
            This operation will be done on the computer runnning the function, since the ComputerName parameter was not set.
			
		.EXAMPLE
			Get-Content computers.txt | Enable-akWakeOnLAN
		
			Enables WakeOnLAN on each computer specified in the text file has wakeon LAN enabled. Returns an object with computername and boolean for WakeOnLANEnabled.
			
	#>
    [CmdletBinding(SupportsShouldProcess=$true)]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string[]]$ComputerName = $ENV:COMPUTERNAME,
        [switch]$EnableSavePower	
	)
    Begin{}
    Process
    {
        ForEach($Computer in $ComputerName)
        {
            $EnableResults = @()
            Try
            {
                $NicConf =  Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer  -Filter "IPEnabled = true" -ErrorAction Stop
            }
            Catch
            {
                Write-Error "Could not connect to WMI Class Win32_NetworkAdapterConfiguation on $Computer"
                Continue
            }
            $nic = Get-WmiObject win32_networkadapter -Filter "DeviceID = $($NicConf.Index)" -ComputerName $Computer
            Write-Verbose "Getting Wake On LAN power settings from WMI"
            $nicPower = gwmi MSPower_DeviceWakeEnable -Namespace root\wmi -ComputerName $Computer | where {$_.instancename -match [regex]::escape($nic.PNPDeviceID) }
            Write-Verbose "Getting NIC Power Sleep settings from WMI"
            $nicPowerEnable = gwmi MSPower_DeviceEnable -Namespace root\wmi -ComputerName $Computer | where {$_.instancename -match [regex]::escape($nic.PNPDeviceID) }
            If($EnableSavePower)
            {                
                If($PSCmdlet.ShouldProcess("$ComputerName","Setting Allow the computer to turn off this device to save power to enabled"))
                {
                    $nicPowerEnable.Enable = $true            
                    $nicPowerEnable.put()
                    $nicPowerEnableCheck = gwmi MSPower_DeviceEnable -Namespace root\wmi -ComputerName $Computer | where {$_.instancename -match [regex]::escape($nic.PNPDeviceID) }
                    $SleepEnabled = $nicPowerEnableCheck.Enable
                }                
            }
            else
            {
                $SleepEnabled = $nicPowerEnable.Enable
            }
            If($PSCmdlet.ShouldProcess("$ComputerName","Setting WakeOnLAN to enabled"))
            {
                $nicPower.Enable = $true            
                $nicPower.put()
            }
            $Enabled = $nicPower.Enable
            $props = @{ComputerName=$ComputerName
                       WakeOnLANEnabled=$Enabled
                       NicSleepEnabled=$SleepEnabled
                      }
            $EnableResults += New-Object -TypeName psobject -Property $props
        }
        If($PSCmdlet.ShouldProcess("$ComputerName","Outputting variable named `$EnableResults"))
        {
            $EnableResults
        }
    }
    End{}
}
