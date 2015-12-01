Function Remove-LANDeskScheduledTask 
{
	<#	
		.SYNOPSIS
			The Remove-LANDeskScheduledTask function removes the specified LANDesk task.
		
		.DESCRIPTION
			The Remove-LANDeskScheduledTask function removes the specified LANDesk task. Requires the ID number of the task to check which can be found by right-clicking task, selecting info, and copying
			the number in the ID field. Alternatively, it can be obtained using Get-LANDeskTaskList function.
		
		.PARAMETER ID
			The ID of the task to check the status on.

		.EXAMPLE
			Remove-LANDeskScheduledTask -ID 877
			
			Returns the status of the LANDesk Task with an ID of 877.
			
		.EXAMPLE
			Get-LANDeskTaskList | Where {$_.TaskName -like "*Adobe*"} | Remove-LANDeskScheduledTask
			
			Returns the status of all Landesk tasks with Adobe in their name. Get-LANDeskTaskList creates a list of all of the scheduled tasks on the LANDesk webserver.
			
		.EXAMPLE
			$oldServer = "LDCONT"
			Get-LANDeskDistributionPackage | {$_.PackagePrimaryFile -like "*$oldServer*"}} | Select PackageName
						
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipelinebyPropertyName=$true)]
		[alias("TaskID")]
		[int]$ID	
	)
	Begin
	{
		If(!($LANDeskWebService))
		{
			Write-Error "Please run Connect-LANDeskServer. This function cannot be performed without an active connection to the LANDesk Web Service."
			Break
		}		
	}
	Process 
	{
		$LANDeskWebService.DeleteTask($ID)
	}
	End{}
}