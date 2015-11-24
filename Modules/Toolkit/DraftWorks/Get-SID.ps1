Function Get-SID
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
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName	
	)
	PROCESS
	{
		Get-Service RemoteRegistry -ComputerName $ComputerName | Start-Service
		###This function is for my work environment.
		##Get SID Number from Registry
		$ServerReg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey("LocalMachine",$ComputerName)
		$sid = ($ServerReg.OpenSubKey("SOFTWARE\Wow6432Node\Intel\LANDesk\Inventory\Custom Fields\")).GetValue("SID")
		$props = @{ComputerName=$ComputerName
					SID=$sid}
		$CompSID = New-Object –TypeName PSObject –Property $props
		$CompSID
		Get-Service RemoteRegistry -ComputerName $ComputerName | Stop-Service	
	}
}