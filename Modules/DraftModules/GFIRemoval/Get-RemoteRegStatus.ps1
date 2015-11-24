Function Get-RemoteRegStatus
{
	<#	
	.SYNOPSIS
		The Get-RemoteRegStatus function determines if the RemoteRegistry service is running on specified computer.
	
	.DESCRIPTION
		The Get-RemoteRegStatus function determines if the RemoteRegistry service is running on specified computer.
	
	.PARAMETER ComputerName
		The name of the computer to run the function against.

	.EXAMPLE
		Get-RemoteRegStatus "THATPC"
		
		Finds out the status of the RemoteRegistry service on THATPC
		
	.EXAMPLE
		Import-CSV .\computers.csv | Get-RemoteRegStatus
	
		Runs the function against each computer listed under the heading ComputerName in computers.csv.
		
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
		try
		{
			Write-Verbose "Running get-service on $ComputerName for the RemoteRegistry service"
			$RemoteRegStatus = (Get-Service -Name RemoteRegistry -ComputerName $ComputerName -ErrorAction Stop).Status
		}
		catch
		{
			Write-Verbose "An error occured while running Get-Service"
			$ErrorMessage = $_.Exception.Message
		}
			Write-Verbose "Creating custom object's properties"
			$props = @{ComputerName=$ComputerName
						RemoteRegistryStatus=$RemoteRegStatus
						ErrorMessage=$ErrorMessage
					}
					Write-Verbose "Creating custom object for output"
		$test = New-Object -TypeName PSObject -Property $props
		$test
	}
	end
	{}
}