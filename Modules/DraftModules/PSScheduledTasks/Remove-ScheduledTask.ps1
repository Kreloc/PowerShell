Function Remove-ScheduledTask 
{
	<#	
		.SYNOPSIS
			A brief description of the Remove-ScheduledTask function.
		
		.DESCRIPTION
			A detailed description of the Remove-ScheduledTask function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			Remove-ScheduledTask <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Get-ScheduledTasks -ComputerName "$env:computername" | Where {$_.Name -like "Test"} | Remove-ScheduledTask
		
			Removes the scheduled task with a name like Test from the computer running the function. Uses the other function Get-ScheduledTasks to retrieve a list of tasks.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName = "",
		[Parameter(Mandatory=$True,
		ValueFromPipelinebyPropertyName=$true)]
		[alias("Name")]
		[string]$TaskName,
		[Parameter(Mandatory=$False,
		ValueFromPipelinebyPropertyName=$true)]
		[string]$Path = '\'
	)
	Begin
	{
		$sch = New-Object -ComObject("Schedule.Service")
	}
	Process 
	{
			Write-Verbose "Connecting to scheduled task service on $ComputerName"
			$sch.Connect($ComputerName)
			$folder = $sch.GetFolder($Path)
			Write-Verbose "Deleting task $TaskName from $ComputerName"
			$folder.DeleteTask("$TaskName",0)			
	}
	End{}
}