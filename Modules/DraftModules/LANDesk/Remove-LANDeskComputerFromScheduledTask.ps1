Function Remove-LANDeskComputerFromScheduledTask 
{
	<#	
		.SYNOPSIS
			The Remove-LANDeskComputerFromScheduledTask function removes the specified computer from the specified LANDesk task.
		
		.DESCRIPTION
			The Remove-LANDeskComputerFromScheduledTask function removes the specified computer from the specified LANDesk task. Requires the ID number of the task to check which can be found by right-clicking task, selecting info, and copying the number in the ID field. Requires the DeviceName of the target computer.
						
		.PARAMETER ComputerName
			The ComputerName or DeviceName of the target computer to remove from the scheduled task.
		
		.PARAMETER ID
			The ID of the task to remove the computer from.

		.EXAMPLE
			Remove-LANDeskComputerFromScheduledTask -ID 877 -ComputerName "THATPC"
			
			Removes the computer named THATPC from the task with a task ID of 877 (LAAWorkStationAgent)
			
		.EXAMPLE
			 Get-LANDeskComputer -Filter {$_.ComputerName -like "*lt*"} | Remove-LANDeskComputerFromScheduledTask -Id 877
			
			Removes all of the computers that have a name with lt in it from the task with an ID of 877. (LAAWorkStationAgent)
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,ValueFromPipeline=$true,
		ValueFromPipelinebyPropertyName=$true)]
		[alias("Device Name")]
		[string]$ComputerName,
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
		$LANDeskWebService.RemoveDeviceFromScheduledTask($ID,$ComputerName)
	}
	End{}
}