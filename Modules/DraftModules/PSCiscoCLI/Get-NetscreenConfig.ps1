Function Get-NetscreenConfig 
{
	<#	
		.SYNOPSIS
			Get-NetscreenConfig returns the output of the get config command on the specified Netscreen. The configuration is also
			exported to a text file.
		
		.DESCRIPTION
			Get-NetscreenConfig returns the output of the get config command on the specified Netscreen. The configuration is also
			exported to a text file. Uses the POSH-SSH Module. You will be prompted once for credentials.
		
		.PARAMETER SwitchName
			The IP Address of the switch to retrieve the configuration file from.

		.EXAMPLE
			Get-NetscreenConfig -SwitchName "192.168.17.1" -Verbose
			
			Connects to the netscreen at 192.168.17.1, prompts for credentials, and displays the output of get config on the netscreen. This output
			is also exported to the default Path location C:\NetScreenConfigs
			
		.EXAMPLE
			Import-CSV .\NetScreens.csv | Get-NetscreenConfig -Verbose
		
			Prompts for credentials once. Displays the output of get config for each netscreen listed under a header of IPAddress in the Netscreens.csv file
			and exports them to the default Path location C:\NetScreenConfigs
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName","IPAddress")]
		[string]$SwitchName,
		[Parameter(Mandatory=$False)]
		[string]$Path = "C:\NetScreenConfigs\"
	)
	Begin
	{
		If(!(Test-Path $Path))
		{
			New-Item $Path -ItemType Directory
		}
		$Date = Get-Date -UFormat %Y%m%d
		$Credentials = Get-Credential		
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
			Write-Verbose "Setting console to not page output"
			$Stream.Write("set console page 0`n")
			Start-Sleep 2
			$Stream.Write("`n")
			$Hostname = $Stream.Read()
			$Hostname = (($Hostname -split '-')[0] -split "`n")[1]
			Write-Verbose "Getting configuration file"
			$Stream.Write("get config`n")
			Write-Verbose "Pausing for 22 seconds for output of get config command to fully display"
			Start-Sleep 22
			$Config = $Stream.Read()
			$Config | Out-File "$($Path)\$($HostName).txt"
			$Stream.Write("unset console page`n")
			Remove-SSHSession -SessionId $SessionId
			Write-Verbose "Removing unecessary lines from config backup"
			Write-Verbose "Looping thru output to eliminate extra data not part of the configuration"
			$file = Get-Content "$($Path)\$($HostName).txt"
			$i = 0
			Do
			{
				$file[$i]
				$i++
			}
			until($file[$i] -match "Total config size" -eq $true -or $i -eq 11)
			$tail = Get-Content "$($Path)\$($HostName).txt" -Tail 5
			$n = 0
			Do
			{
				$tail[$n]
				$n++
			}
			until($tail[$n] -match "->" -eq $true -or $n -eq 6)
			$begin = $i + 1
			$end = 5 - $n + 1
			$output = $file[$begin..($file.count - $end)]
			$output | Out-File "$($Path)\$($HostName).txt"
			$output
			If($n -eq 6 -or $i -eq 11)
			{
				"$SwitchName needed longer to display its configuration" > "$($Path)\$($HostName)HadIssues.txt"
			}
		}
	}
	End{}
}