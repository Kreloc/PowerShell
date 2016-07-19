Function Enable-akRDP
{
	<#	
		.SYNOPSIS
			Enable-akRDP enables RDP on targeted computer and creates a RDP file for the connection.
		
		.DESCRIPTION
			Enable-akRDP enables RDP on targeted computer and creates a RDP file for the connection. Sets two
            values in the registry that enable Remote Desktop with a port number of 4358 (Default value for port number, can be changed). Creates an RDP file
            named $ComputerName-$UserName.rdp on the computer running this function.
		
		.PARAMETER ComputerName
			The name of the computer(s) to enable RDP on.
        
        .PARAMETER UserName
            The username of the person who will be connecting to the computer.

        .EXAMPLE
            Enable-akRDP -Verbose -WhatIf

            This will run the function on the current computer, with all the default values for the parameters.
            No changes will take place and the messages for the -Whatif parameter will display along with the Verbose messages.
			
		.EXAMPLE
			Enable-akRDP -ComputerName "THATPC" -UserName "jdoe" -PortNumber 4459 -Domain "fake.gov" -Path "C:\RDPConnectionFiles\"
			
			This will enable RDP on the computer named THATPC for the user jdoe for the domain name fake.gov

        .EXAMPLE
            Enable-akRDP -ComputerName "OTHERPC" -UserName "bdoll" -Verbose -WhatIf

            This will show the verbose and WhatIf messages from running this functions. No changes will be made.
			
		.EXAMPLE
			Imoprt-CSV .\RDPNeeded.csv | Enable-akRDP
		
			Enables RDP on each computer for under the ComputerName and UserName headers in the RDPNeeded.csv file.
            
        .NOTES
            Enable RDP Access to computers that are going to be connected to thru a VPN.
            Support for -Whatif added
            	
	#>
	[CmdletBinding(SupportsShouldProcess=$true)]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string[]]$ComputerName = $env:COMPUTERNAME,
        [Parameter(ValueFromPipelinebyPropertyName=$true)]
        [string]$UserName = $env:USERNAME,
        [Parameter(Mandatory=$False,ValueFromPipelinebyPropertyName=$true)]
        [int]$PortNumber = 4489,
        [Parameter(Mandatory=$False,ValueFromPipelinebyPropertyName=$true)]
        [string]$Domain = $env:USERDNSDOMAIN,
        [string]$Path = ".\"
	)
    Begin{}
    Process
    {
        ForEach($Computer in $ComputerName)
        {
            If($Path[-1] -ne '\')
            {
                Write-Verbose "Adding slash to end of $Path"
                $Path = $Path + '\'
            }
            [string]$PortNumber = $PortNumber
            Write-Verbose "Testing if $Computer is online"
            If(Test-Connection -ComputerName $Computer -Count 2 -Quiet)
            {
                Write-Verbose "$Computer is online, proceeding with enabling RDP"
                Write-Verbose "Adding $UserName to Remote Desktop Group on $Computer"
                $ADSIUser = [ADSI]("WinNT://$Domain/$UserName")
                $ADSIGroup = [ADSI]("WinNT://$Computer/Remote Desktop Users")
                If($PSCmdlet.ShouldProcess("$Computer","Adding user $($UserName) to Remote Desktop Users local group"))
                {
                    $ADSIGroup.PSBase.Invoke("Add",$ADSIUser.PSBase.Path)
                }        
                Write-Verbose "Attempting to start RemoteRegistry service"
                $resSCServiceStart = & C:\Windows\System32\sc.exe \\$Computer start "RemoteRegistry"
                Start-Sleep 0.8
                Write-Verbose "Checking that RemoteRegistry is running on $Computer"
                $RemoteRegistry = Get-Service RemoteRegistry -ComputerName $Computer
                If($RemoteRegistry.Status -eq "Running")
                {
                    Write-Verbose "Setting registry keys for RDP connections to $Computer"
                    $HKLM   = [microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$Computer)            
                    $TerminalServerKey  = $HKLM.OpenSubKey("SYSTEM\\CurrentControlSet\\Control\\Terminal Server\\", $true)
                    If($PSCmdlet.ShouldProcess("$Computer","Setting $($TerminalServerKey) registry key fDenyTSConnections value to 0 as Dword"))
                    {                      
                        $TerminalServerKey.SetValue("fDenyTSConnections","0",'Dword')
                    }
                    $WinStationRDPTCP = $HKLM.OpenSubKey("SYSTEM\\CurrentControlSet\\Control\\Terminal Server\\WinStations\RDP-Tcp\\", $true)
                    If($PSCmdlet.ShouldProcess("$Computer","Setting $($WinStationRDPTCP) registry key PortNumber value to $($PortNumber) as Dword"))
                    {                      
                        $WinStationRDPTCP.SetValue("PortNumber",$PortNumber,[Microsoft.Win32.RegistryValueKind]::DWord)
                    }
                    Write-Verbose "Stopping RemoteRegistry service on $Computer"
                    Restart-Service -InputObject $RemoteRegistry
                    $resSCServiceStop = & C:\Windows\System32\sc.exe \\$Computer stop "RemoteRegistry"
                    Write-Verbose "Creating RDP connection file named $Computer-$($UserName).rdp"
                    $hereString = @"

audiomode:i:2
authentication level:i:0
autoreconnection enabled:i:1
bitmapcachepersistenable:i:1
compression:i:1
disable cursor setting:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:1
disable wallpaper:i:1
displayconnectionbar:i:1
keyboardhook:i:2
redirectclipboard:i:1
redirectcomports:i:0
redirectdrives:i:0
redirectprinters:i:0
redirectsmartcards:i:0
session bpp:i:16
prompt for credentials:i:0
promptcredentialonce:i:1
"@
                    $out = @()
                    $out += "full address:s:" + $Computer + ':' + $PortNumber
                    $out += "username:s:" + $UserName + '@' + $Domain
                    $out += $hereString
                    $outFileName = $Path + $Computer + "-" + $UserName + ".rdp"
                If($PSCmdlet.ShouldProcess("$env:COMPUTERNAME","Creating rdp connection file to $($OutFileName)"))
                {
                    $out | out-file $outFileName
                }
                }#End If RemoteRegistry Service is running
                else
                {
                    Write-Warning "RemoteRegistry is not running on $Computer"
                    Continue
                }

            }#End If Test-Connection sucessfully pinged target computer
            else
            {
                Write-Warning "$Computer could not be pinged"
                Continue
            }
        } #End ForEach
    } #End Process block
    End{}
}