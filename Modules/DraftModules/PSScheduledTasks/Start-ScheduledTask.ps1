Function Start-ScheduledTask 
{
	<#	
		.SYNOPSIS
			Start-ScheduledTask starts a scheduled task on the local computer or a remote computer.
		
		.DESCRIPTION
			Start-ScheduledTask starts a scheduled task on the local computer or a remote computer. Uses the Schedule.Service COM object.
		
		.PARAMETER ComputerName
			The name of the computer to connect to. If this parameter isn't specified, the local computer is used.
			
		.PARAMETER TaskName
			The name of the scheduled task to start.
			
		.PARAMETER Path
			The location the task to start exists in. If this parameter isn't specified, the local computer is used.		

		.EXAMPLE
			Start-ScheduledTask -TaskName "Scheduled Task Demo"
			
			Starts the task named Scheduled Task Demo in the root, \, location on the local computer.
			
		.EXAMPLE
			Start-ScheduledTask -TaskName "Scheduled Task Demo" -ComputerName "THATPC" -Path "\DemoFolder\"
			
			Starts the task named Scheduled Task Demo in the subfolder, \DemoFolder\, on the remote computer named THATPC.	
			
		.EXAMPLE
			Get-ScheduledTasks -ComputerName "THATPC" | Where {$_.Name -like "*Remote Adobe CC Updates*"} | Start-ScheduledTask
			
			Starts the task that has Remote Adobe CC Updates in the name on the remote computer THATPC.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName")]
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
		$sch.Connect($ComputerName)
		$folder = $sch.GetFolder($Path).GetTask($TaskName).Run(1)
	}
	End
	{
		[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sch) | Out-Null
		Remove-Variable sch
	}
}