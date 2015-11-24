Function Set-SID
{
		<#	
		.SYNOPSIS
			Retrives the SID number placed in the registry on the remote computer.
		
		.DESCRIPTION
			Retrives the SID number placed in the registry on the remote computer. Starts and stops remote registry.
		
		.PARAMETER ComputerName
			The name of the computer to retrieve the information from.
		
		.EXAMPLE
			Get-SID -ComputerName <ComputerName>
			
		.EXAMPLE
			Get-Content computers.txt | Get-SID
		
		.NOTES
			Get-SID retrieves the entered SID key value. Starts and stops the remoteregistry service.
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		$ComputerName,
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		$SID	
	)
	PROCESS
	{
		Write-Verbose "Pinging $ComputerName"
		If(test-connection -ComputerName $ComputerName -Count 1 -Quiet)
		{
			Write-Verbose "Starting RemoteRegistry Service on $ComputerName"            
	 		$resSCServiceStart = & C:\Windows\System32\sc.exe \\$ComputerName start "RemoteRegistry" 
			###This function is for my work environment.
			##Get SID Number from Registry
			$HKLM = [microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$ComputerName)
			$ValueName = "SID"
			#True needs to be set to have write access.
			$subkey = ($HKLM.OpenSubKey("SOFTWARE\Wow6432Node\Intel\LANDesk\Inventory\Custom Fields\",$True))
			$subkey.SetValue($ValueName, $SID, [Microsoft.Win32.RegistryValueKind]::String)
			$resSCServiceStop = & C:\Windows\System32\sc.exe \\$ComputerName stop "RemoteRegistry"
			try
				{
					$RemoteRegStatus = (Get-Service -Name RemoteRegistry -ComputerName $ComputerName -ErrorAction Stop).Status
				}
				catch
				{
					$ErrorMessage = $_.Exception.Message
				}
						$props = @{ComputerName=$ComputerName
						SID=$sid
						RemoteRegistryStatus=$RemoteRegStatus
						Online=$True}
			$CompSID = New-Object –TypeName PSObject –Property $props
		}
		else
		{
						$props = @{ComputerName=$ComputerName
						SID="False"
						RemoteRegistryStatus="False"
						Online=$False}
			$CompSID = New-Object –TypeName PSObject –Property $props
		}
		$CompSID
	}
}