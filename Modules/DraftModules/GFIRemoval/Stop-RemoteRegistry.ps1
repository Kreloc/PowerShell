Function Stop-RemoteRegistry
{
	<#	
		.SYNOPSIS
			The Stop-RemoteRegistry function stops the RemoteRegistry serice on the specified computer.
		
		.DESCRIPTION
			The Stop-RemoteRegistry function stops the RemoteRegistry serice on the specified computer using the sc.ece command line tool.
		
		.PARAMETER ComputerName
			The name of the computer to stop RemoteRegistry service on.

		.EXAMPLE
			Stop-RemoteRegistry -ComputerName "THATPC"
			
			Stops the RemoteRegistry service on THATPC
			
		.EXAMPLE
			Import-CSV .\ComputersToCheck.csv | Get-RemoteRegStatus | Where {$_.RemoteRegistryStatus -like "Running"} | Stop-RemoteRegistry
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName	
	)
	Begin{}
	Process 
	{
			Write-Verbose "Attempting to stop RemoteRegistry service using sc.exe on $ComputerName"
			$resSCServiceStop = & C:\Windows\System32\sc.exe \\$ComputerName stop "RemoteRegistry"
	}
	End{}
}