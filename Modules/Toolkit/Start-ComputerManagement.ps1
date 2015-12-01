Function Start-ComputerManagement 
{
	<#	
		.SYNOPSIS
			Start-ComputerManagement starts the Computer Management snap-in on the local computer or a remote computer.
		
		.DESCRIPTION
			Start-ComputerManagement starts the Computer Management snap-in on the local computer or a remote computer.
		
		.PARAMETER ComputerName
			The name of the computer to open Computer Management on.

		.EXAMPLE
			Start-ComputerManagement -ComputerName "THATPC"
			
			Starts the Computer Management for THATPC
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName")]
		[string]$ComputerName = $env:COMPUTERNAME
	)
	Begin{}
	Process 
	{
		Write-Verbose "Checking running against local computer or remote computer"
		If (($ComputerName -like "localhost") -or ($ComputerName -like ".") -or ($ComputerName -like "127.0.0.1") -or ($ComputerName -like "$env:computername")) 
		{
			Write-Verbose "Starting Computer Management on local computer"
			$command="compmgmt.msc"
			Start-Process $command 
		}
		else
		{
			Write-Verbose "Starting Computer Management on $($ComputerName)"
			$command="compmgmt.msc"
			$arguments = "/computer:$computername"
			Start-Process $command $arguments
		}
	}
	End{}
}