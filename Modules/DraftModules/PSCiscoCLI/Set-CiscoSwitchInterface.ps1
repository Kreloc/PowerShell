Function Set-CiscoSwitchInterface 
{
	<#	
		.SYNOPSIS
			A brief description of the Set-CiscoSwitchInterface function.
		
		.DESCRIPTION
			A detailed description of the Set-CiscoSwitchInterface function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			Set-CiscoSwitchInterface <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Set-CiscoSwitchInterface
		
			Explanation of this example where computers.csv had SwitchName as a header.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$SwitchName,
		[Parameter(Mandatory=$True,
		ValueFromPipelinebyPropertyName=$true)]
		[string]$Port	
	)
	Begin{}
	Process 
	{
		$Credentials = Get-Credential
		$Password = $Credentials.GetNetworkCredential().password.ToString()
		$Connection = New-SSHSession -ComputerName $SwitchName -Credential $Credentials
		If($Connection.Connected -notlike "True")
		{
			"Exiting script, failed to connect to switch $SwitchName. Check name or ip address and credentials provided"
			break
		}
		$SessionID = $Connection.SessionId
		$Session = Get-SSHSession -SessionId $SessionId
		$Stream = $Session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
		Start-Sleep 2
		$Stream.Write("Enable `n")
		$Stream.Write("$Password`n")
		$Stream.Write("Configure terminal`n")
		$Stream.Write("interface $port`n")
	}
	End{}
}