Function Disable-akWakeOnLAN
{
	<#	
		.SYNOPSIS
			Disables WakeOnLAN on specified computer.
		
		.DESCRIPTION
			Disables WakeOnLAN on specified computer. Uses three WMI Classes.
		
		.PARAMETER ComputerName
			The name of the computer to enable for WakeOnLAN.
		
		.EXAMPLE
			Disable-akWakeOnLAN <ComputerName>
			
			Disable WakeOnLAN on specified computer. Returns an object with computername and boolean for WakeOnLANEnabled.

        .EXAMPLE
            Disable-akWakeOnLAN -DisableSavePower

            Disables WakeOnLAN on specified computer for active NIC. Also sets that NIC to be Allow this device to turn off this computer to save power to disabled.
            This operation will be done on the computer runnning the function, since the ComputerName parameter was not set.
			
		.EXAMPLE
			Get-Content computers.txt | Disable-akWakeOnLAN
		
			Disables WakeOnLAN on each computer specified in the text file has wakeon LAN enabled. Returns an object with computername and boolean for WakeOnLANEnabled.
			
	#>
    [CmdletBinding(SupportsShouldProcess=$true)]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string[]]$ComputerName = $ENV:COMPUTERNAME,
        [switch]$DisableSavePower	
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
            If($DisableSavePower)
            {                
                If($PSCmdlet.ShouldProcess("$ComputerName","Setting Allow the computer to turn off this device to save power to disabled"))
                {
                    $nicPowerEnable.Enable = $false           
                    $nicPowerEnable.put()
                    $nicPowerEnableCheck = gwmi MSPower_DeviceEnable -Namespace root\wmi -ComputerName $Computer | where {$_.instancename -match [regex]::escape($nic.PNPDeviceID) }
                    $SleepEnabled = $nicPowerEnableCheck.Enable
                }                

            }
            else
            {
                $SleepEnabled = $nicPowerEnable.Enable
            }
            If($PSCmdlet.ShouldProcess("$ComputerName","Setting WakeOnLAN to disabled"))
            {
                $nicPower.Enable = $false            
                $nicPower.put()
            }
            $Enabled = $nicPower.Enable
            $props = @{ComputerName=$ComputerName
                       WakeOnLANEnabled=$Enabled
                       NicSleepEnabled=$SleepEnabled
                      }
            $DisableResults += New-Object -TypeName psobject -Property $props
        }
        If($PSCmdlet.ShouldProcess("$ComputerName","Outputting variable named `$DisableResults"))
        {
            $DisableResults
        }
    }
    End{}
}
