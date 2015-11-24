Function Get-CiscoRunningConfig 
{
	<#	
		.SYNOPSIS
			Get-CiscoRunningConfig returns the output of the show running-config command on the specified Cisco switch or router. The configuration is also
			exported to a text file.
		
		.DESCRIPTION
			Get-CiscoRunningConfig returns the output of the show running-config command on the specified Cisco switch or router. The configuration is also
			exported to a text file. Uses the POSH-SSH Module. You will be prompted once for credentials.
		
		.PARAMETER SwitchName
			The IP Address of the switch or router to retrieve the running-config from.

		.EXAMPLE
			Get-CiscoRunningConfig -SwitchName 192.168.27.52
			
			Returns the output of the show running-config on the Cisco switch with an address of 192.168.27.52 and saves it to a text file in the
			directory specified by the Path parameter.
			
		.EXAMPLE
			Import-CSV .\SwitchSampleGroup.csv | Get-CiscoRunningConfig -Verbose
		
			Gets the output of show running-config on the Cisco switches listed under a SwitchName or IPAddress header.
			
		.NOTES
			If needed, move the $Credentials = Get-Credential and $Password = $Credentials.GetNetworkCredential().password.ToString()
			into the Process block if each device uses different credentials.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName","IPAddress")]
		[string]$SwitchName,
		[Parameter(Mandatory=$False)]
		[string]$Path = "C:\CiscoConfigs\"
	)
	Begin
	{
		If(!(Test-Path $Path))
		{
			New-Item $Path -ItemType Directory
		}
		$Date = Get-Date -UFormat %Y%m%d
		$Credentials = Get-Credential
		$Password = $Credentials.GetNetworkCredential().password.ToString()
	}
	Process 
	{
		Write-Verbose "Iniating connection to $SwitchName"
		$Connection = New-SSHSession -ComputerName $SwitchName -Credential $Credentials -AcceptKey
		If($Connection.Connected -notlike "True")
		{
			Write-Verbose "Failed to connect to $SwitchName"
			$SwitchName >> "$($Path)\FailedToConnect - $($Date).txt"
		}
		else
		{
			Write-Verbose "Creating SSH Session to $SwitchName"
			$SessionID = $Connection.SessionId
			$Session = Get-SSHSession -SessionId $SessionId
			Write-Verbose "Creating streamreader for output of switch commands"
			$Stream = $Session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
			Write-Verbose "Pausing for two seconds"
			Start-Sleep 2
			Write-Verbose "Sending enable command to enter Privleged EXEC on switch"
			$Stream.Write("Enable `n")
			Write-Verbose "Pausing for two seconds"
			Start-Sleep 2
			$Stream.Write("$Password`n")
			Write-Verbose "Pausing for two seconds"
			Start-Sleep 2
			Write-Verbose "Setting terminal length to zero to bypass pauses and breaks in output"
			$Stream.Write("terminal length 0`n")
			Write-Verbose "Pausing for two seconds"
			Start-Sleep 2
			Write-Verbose "Reading the stream of commands inputted so far"
			$EnableTest = $Stream.Read()
			Write-Verbose "Sending the show running-config command to $SwitchName"
			$Stream.Write("show running-config`n")
			Write-Verbose "Pausing for 22 seconds to let output finish"
			Start-Sleep 22
			Write-Verbose "Capturing output of show running-config run on $SwitchName"
			$CiscoConfig = $Stream.Read()
			$CiscoConfig | Out-File "$($Path)\$($SwitchName) - $($Date) Config.txt"
			Start-Sleep 4
			Write-Verbose "Removing SSH Session from $SwitchName"
			Remove-SSHSession -SessionId $SessionId
			Write-Verbose "Removing unecessary lines from config backup"
			Write-Verbose "Looping thru output to eliminate extra data not part of the configuration"
			$file = Get-Content "$($Path)\$($SwitchName) - $($Date) Config.txt"
			$i = 0
			Do
			{
				$file[$i]
				$i++
			}
			until($file[$i] -match "Building" -eq $true -or $i -eq 5)
			$hostname = (($file -match "hostname") -replace "hostname ","")
			$tail = Get-Content "$($Path)\$($SwitchName) - $($Date) Config.txt" -Tail 3
			$n = 0
			Do
			{
				$tail[$n]
				$n++
			}
			until($tail[$n] -match "#" -eq $true -or $n -eq 5)
			$end = 3 - $n + 1
			$output = $file[$i..($file.count - $end)]
			$output
			$output | Out-File "$($Path)\$($HostName)-config.txt"
			If($i -eq 5 -or $n -eq 5)
			{
				"$SwitchName" | OutFile "$($Path)\$SwitchName - Config incomplete.txt"
			}
			Remove-Item "$($Path)\$($SwitchName) - $($Date) Config.txt"
		}
	}
	End{}
}