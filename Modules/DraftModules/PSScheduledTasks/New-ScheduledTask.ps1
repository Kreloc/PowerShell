Function New-ScheduledTask 
{
	<#	
		.SYNOPSIS
			A brief description of the New-ScheduledTask function.
		
		.DESCRIPTION
			A detailed description of the New-ScheduledTask function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			New-ScheduledTask <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | New-ScheduledTask
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
		.NOTES
			This function is unfinished, please do not use it.
			I included this, but my preferred method is to create the task using the Task Scheduler Wizard on one computer and then export the xml
			of that task. Refer to Set-ScheduledTask and Export-ScheduledTask.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName")]
		[string]$ComputerName = "",
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("Name")]
		[string]$TaskName,
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Path = '\',
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Description,
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Triggers,
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Actions					
	)
	Begin
	{
		$sch = New-Object -ComObject("Schedule.Service")	
	}
	Process 
	{
		Write-Verbose "Connecting to schedule service"
		$sch.Connect($ComputerName)
		$folder = $sch.GetFolder($Path)
		Write-Verbose "Starting creation of new task"
		$TaskDefinition = $sch.NewTask(0)
		Write-Verbose "Setting registration description info for new task"
		$RegistrationInfo = $TaskDefinition.RegistrationInfo
		$RegistrationInfo.Description = $Description
		Write-Verbose "Setting task settings for new task"
		$Settings = $TaskDefinition.Settings
		$Settings.Enabled = $True
		$Settings.StartWhenAvailable = $True
		$Settings.Hidden = $False
		Write-Verbose "Setting triggers for new task"
		$TaskTriggers = $TaskDefinition.Triggers
		$TaskTriggers.StartBoundary = "2015-10-01T04:00:00"
		$TaskTriggers.DaysInterval = 1
		$TaskTriggers.Id = "DailyTriggerId"
		$TaskTriggers.Enabled = $True
		Write-Verbose "Setting actions for new task"
		$Action = $TaskDefinition.Actions.Create(0)
		$Action.Path = "C:\Scripts\PSScheduledTaskDemo.bat"
		$Action.Arguments = ''
		$Action.WorkingDirectory = "C:\Scripts"
		Write-Verbose "Creating new task"
		$folder.RegisterTaskDefinition($Description, $TaskDefinition, 6, "System", $null, 5) | Out-Null
	}
	End
	{
		[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sch) | Out-Null
		Remove-Variable sch
	}
}