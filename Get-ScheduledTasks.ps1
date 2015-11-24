Function Get-ScheduledTasks 
{
	<#	
		.SYNOPSIS
			A brief description of the Get-ScheduledTasks function.
		
		.DESCRIPTION
			A detailed description of the Get-ScheduledTasks function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			Get-ScheduledTasks <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Get-ScheduledTasks
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName	
	)
	Begin
	{
		$sch = New-Object -ComObject("Schedule.Service")
	}
	Process 
	{
			Write-Verbose "Connecting to scheduled taks service on $ComputerName"
			$sch.Connect($ComputerName)
			$root = $sch.GetFolder("\")
			Write-Verbose "Retrieving a list of tasks from $ComputerName"
			$tasklist = $root.GetTasks("0")
			$tasklist | Select Name, Definition, Enabled, LastRunTime, LastTaskResult, NextRunTime, NumberOfMissedRuns, Path, State, XML, @{name="ComputerName";expression={$ComputerName}}
	}
	End{}
}