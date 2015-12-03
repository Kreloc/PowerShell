Function Get-LANDeskTaskMachineStatus 
{
	<#	
		.SYNOPSIS
			The Get-LANDeskTaskMachineStatus function returns the status of the specified LANDesk task.
		
		.DESCRIPTION
			The Get-LANDeskTaskMachineStatus function returns the status of the specified LANDesk task. Requires the ID number of the task to check which can be found by right-clicking task, selecting info, and copying
			the number in the ID field.
		
		.PARAMETER ID
			The ID of the task to check the status on.

		.EXAMPLE
			Get-LANDeskTaskMachineStatus -ID 877
			
			Returns the status of the machines that ran the LANDesk Task with an ID of 877.
			
						
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
		($LANDeskWebService.GetTaskMachineStatus($ID)).DeviceData
	}
	End{}
}