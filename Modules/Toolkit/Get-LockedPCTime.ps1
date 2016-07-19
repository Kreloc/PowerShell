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
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string[]]$ComputerName	= $ENV:COMPUTERNAME
	)
	Begin{}
	Process 
	{
        $Results = @()
        ForEach($Computer in $ComputerName)
        {
		    Write-Verbose "Retrieving security event logs from $Computer"
            Try
            {
		        $LockLogs = Get-WinEvent -ComputerName $Computer -FilterHashTable @{LogName ='Security';id=4800} -ErrorAction Stop | Sort TimeCreated -Descending
            }
            Catch
            {
                Write-Warning "Could not find lock event in Security log on $Computer"
                $Issue = $True
            }
            Try
            {
		        $UnLockLogs = Get-WinEvent -ComputerName $Computer -FilterHashTable @{LogName ='Security';id=4801} -ErrorAction Stop | Sort TimeCreated -Descending
            }
            Catch
            {
                Write-Warning "Could not find unlock event in Security log on $Computer"
                $Issue = $True
            }
		    Write-Verbose "Determining if computer $Computer is locked"
            If($LockLogs -and $UnLockLogs)
            {
                Write-Verbose "Determing amount of time computer has been locked"
		        If($LockLogs[0].TimeCreated -gt $UnLockLogs[0].TimeCreated)
		        {
			        $LockedTime = (Get-Date) - $LockLogs[0].TimeCreated
			        $TimePCLocked = $LockedTime.ToString()
			        $props = @{ComputerName=$Computer
						        TimeLocked=$TimePCLocked
						        Locked=$True
                                Issue=$False
					        }
		        }
            }
		    else
		    {
			    $props = @{ComputerName=$Computer
						    TimeLocked="Not Locked"
						    Locked=$False
                            Issue=$Issue
						    }
		    }
		    Write-Verbose "Creating custom output object"	
		    $Results += New-Object -TypeName PSObject -Property $props
		}
        $Results
	}
	End{}
}	