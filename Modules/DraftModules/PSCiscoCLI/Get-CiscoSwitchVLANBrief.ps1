Function Get-CiscoSwitchVLANBrief 
{
	<#	
		.SYNOPSIS
			Get-CiscoSwitchVLANBrief returns the output of the Cisco Command Show Vlan Brief for the specified switch.
		
		.DESCRIPTION
			Get-CiscoSwitchVLANBrief returns the output of the Cisco Command Show Vlan Brief for the specified switch. Uses the POSH-SSH module and requires credentials gathered
			with Get-Credential
		
		.PARAMETER SwitchName
			The name or ip address of the switch to connect to. At this time, using switch names is not supported, please use the switch's IP Address.

		.EXAMPLE
			Get-CiscoSwitchVLANBrief 192.168.27.52
			
			Returns the output of the show vlan brief on the Cisco switch with an address of 192.168.27.52
			
		.EXAMPLE
			Import-CSV .\computers.csv | Get-CiscoSwitchVLANBrief
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
		.NOTES
		 	The module POSH-SSH is needed for this function to work.	
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$SwitchName
	)
	Begin
	{
		#Create object of switch names to ip address$ to account for input of switch name
		$Credentials = Get-Credential
		$Password = $Credentials.GetNetworkCredential().password.ToString()
	}
	Process 
	{
		$Connection = New-SSHSession -ComputerName $SwitchName -Credential $Credentials
		If($Connection.Connected -notlike "True")
		{
			"Exiting script, failed to connect to switch $SwitchName. Check name or ip address and credentials provided"
			Write-Verbose "Failed to connect to $SwitchName"
		}
		else
		{
			$SessionID = $Connection.SessionId
			$Session = Get-SSHSession -SessionId $SessionId
			$Stream = $Session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
			Start-Sleep 2
			$Stream.Write("Enable `n")
			$Stream.Write("$Password`n")
			$Stream.Write("show vlan brief`n")
			Start-Sleep 2
			$Vlans = $Stream.Read()
			$Vlans
			Start-Sleep 5
			If($Vlans)
			{
				Remove-SSHSession -SessionId $SessionId	| Out-Null
			}
			else
			{
				Write-Verbose "Vlan information was not retrieved, closing session anyway."
				Remove-SSHSession -SessionId $SessionId | Out-Null
			}
		}
	}
	End{}
}