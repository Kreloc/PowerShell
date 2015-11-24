Function Get-GFIInstalledStatus
{
	<#	
		.SYNOPSIS
			The Get-GFIInstalledStatus function checks to make sure GFI has been uninstalled.
		
		.DESCRIPTION
			The Get-GFIInstalledStatus function checks to make sure GFI has been uninstalled by accessing the application
			event log and searching for the uninstallation event of GFI Backup 2010.
		
		.PARAMETER ComputerName
			The name of the computer to check the installation staus for GFI. 

		.EXAMPLE
			Get-GFIInstalledStatus <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\GFIPcs.csv | Get-GFIInstalledStatus
		
			Runs this function against each computer listed in GFIPcs.csv under the header ComputerName.
			
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
		Write-Verbose "Pinging $ComputerName"
		If((Test-ComputerConnection -ComputerName $ComputerName).Online -eq $True)
		{
			Write-Verbose "Reading the application log for $ComputerName"
			try
			{
				$MsiInstallerAppLogs = Get-WinEvent -ErrorAction "Stop" -FilterHashtable @{logname="application"; providername="MsiInstaller"; Id=1034} -ComputerName $ComputerName		
			}
			Catch
			{
				Write-Verbose "Ran into an error while retrieving application event logs"
				$ErrorMessage = $_.Exception.Message
    			$FailedItem = $_.Exception.ItemName
			}
			Finally
			{}
			$LogMessage = $MsiInstallerAppLogs | Where {$_.Message -like "*GFI*"} | Select -ExpandProperty Message
			If($LogMessage)
			{
				Write-Verbose "Uninstallation event of GFI Backup 2010 was found, creating custom object properties"
				$props = @{ComputerName=$ComputerName
							LogMessage=$LogMessage
							Online=$True
				}	
			}
			else
			{
				Write-Verbose "No uninstallation event was found  on $ComputerName, creating custom object properties"
				$props = @{ComputerName=$ComputerName
							LogMessage=$False
							Online=$True
							ErrorMessage=$ErrorMessage
							FailedItem=$FailedItem
				}
			}
		}
		Else
		{
			Write-Verbose "$ComputerName was offline, creating custom object properties"
							$props = @{ComputerName=$ComputerName
							LogMessage=$False
							Online=$False
				}
		}
		Write-Verbose "Creating custom object"
		$RemovedGFI = New-Object –TypeName PSObject –Property $props		
		$RemovedGFI
	}
	End{}
}