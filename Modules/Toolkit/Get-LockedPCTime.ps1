Function Get-LockedPCTime
{
	<#	
		.SYNOPSIS
			Get-LockedPCTime function retrieves the time that a user last locked his or her computer. Returns time locked in format of hour hour:minute minute:second second.Milliseconds
		
		.DESCRIPTION
			Get-LockedPCTime function retrieves the time that a user last locked his or her computer using Security logs with an event id of 4800 and 4801.
			Function wants need to be run from an Administrative Console.
		
		.PARAMETER ComputerName
			The name of the computer to check how long it has been locked.
			
		.EXAMPLE
			Get-LockedPCTime -ComputerName
			
			Gets how long long the targetted pc has been locked.
			
		.EXAMPLE
			Import-CSV .\computers.csv | Get-LockedPCTime -Verbose
		
			Runs this function against each computername listed under the heading ComputerName in the computers.csv file
			and displays the Write-Verbose messages on the console as the funciton runs.
			
		.NOTES
			Must be run as Administrator to work on local computer (Not sure why you would do that, but it will only work with PowerShell run as Administrator.
			Works without powershell being run as Administrator on remote computers.
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
		Write-Verbose "Retrieving security event logs from $ComputerName"
		$LockLogs = Get-WinEvent -ComputerName $ComputerName -FilterHashTable @{LogName ='Security';id=4800} | Sort TimeCreated -Descending
		$UnLockLogs = Get-WinEvent -ComputerName $ComputerName -FilterHashTable @{LogName ='Security';id=4801} | Sort TimeCreated -Descending
		Write-Verbose "Determining if computer $ComputerName is locked"
		If($LockLogs[0].TimeCreated -gt $UnLockLogs[0].TimeCreated)
		{
			$LockedTime = (Get-Date) - $LockLogs[0].TimeCreated
			$TimePCLocked = $LockedTime.ToString()
			$props = @{ComputerName=$ComputerName
						TimeLocked=$TimePCLocked
						Locked=$True
					}
		}
		else
		{
			$props = @{ComputerName=$ComputerName
						TimeLocked="Not Locked"
						Locked=$False
						}
		}
		Write-Verbose "Creating custom output object"	
		$Results = New-Object -TypeName PSObject -Property $props
		$Results
	}
	End{}
}	