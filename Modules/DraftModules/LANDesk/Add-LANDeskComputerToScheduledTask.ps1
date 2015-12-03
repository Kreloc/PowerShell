Function Add-LANDeskComputerToScheduledTask 
{
	<#	
		.SYNOPSIS
			The Add-LANDeskComputerToScheduledTask function adds the specified computer to the specified LANDesk task.
		
		.DESCRIPTION
			The Add-LANDeskComputerToScheduledTask function adds the specified computer to the specified LANDesk task. Requires the ID number of the task to check which can be found by right-clicking task, selecting info, and copying
			the number in the ID field. Requires the DeviceName of the target computer.
						
		.PARAMETER ComputerName
			The ComputerName or DeviceName of the target computer to add to the scheduled task.
		
		.PARAMETER ID
			The ID of the task to add the computer to.

		.EXAMPLE
			Add-LANDeskComputerToScheduledTask -ID 877 -ComputerName "THATPC"
			
			Adds the computer named THATPC to the task with a task ID of 877 (LAAWorkStationAgent)
			
		.EXAMPLE
			 Get-LANDeskComputer -Filter {$_.ComputerName -like "*lt*"} | Add-LANDeskComputerToScheduledTask -Id 877
			
			Adds all of the computers that have a name with lt in it to the task with an ID of 877. (LAAWorkStationAgent)
			
		.EXAMPLE
			Start-LANDeskQuery "Inventory Scanner Version" | Add-LANDeskComputerToScheduledTask -Id 877
			
			Adds all of the computers returned by the Inventory Scanner Version query and adds them to the task with an ID of 877. The query
			is set to find computers with a version older than the most current.
						
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
		$LANDeskWebService.AddDeviceToScheduledTask($ID,$ComputerName)
	}
	End{}
}