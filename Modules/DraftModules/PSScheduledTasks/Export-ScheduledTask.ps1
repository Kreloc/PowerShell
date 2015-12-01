Function Export-ScheduledTask 
{
	<#	
		.SYNOPSIS
			Export-ScheduledTask gets a task by name and exports an xml file of that task.
		
		.DESCRIPTION
			Export-ScheduledTask gets a task by name and exports an xml file of that task. Can be run on local computer or run on a remote computer
			by supplying the ComputerName parameter a computer name. Uses the Schedule.Service COM object and its methods.
		
		.PARAMETER ComputerName
			The name of the computer to export the task from. If parameter isn't used, the local computer
			is used.
			
		.PARAMETER TaskName
			The name of the task to be exported.
			
		.PARAMETER Path
			The path the task to be exported exists in. Root level being \ and is what is used if 
			this parameter isn't specified.
			
		.PARAMETER Destination
			The directory path to output the exported xml file. User profile's Documents folder will be used
			if this parameter isn't specifed.			

		.EXAMPLE
			Export-ScheduledTask -TaskName "GoogleUpdateTaskMachineCore"
			
			Exports the task GoogleUpdateTaskMachineCore on the local computer to the user's Documents folder
			with a name of GoogleUpdateTaskMachineCore.xml.
			
		.EXAMPLE
			Export-ScheduledTask -TaskName "LANDESK Agent Health Bootstrap Task" -ComputerName "THATPC" -Destination "C:\Tasks"
			
			Exports the task LANDESK Agent Health Bootstrap Task from a computer named THATPC to the folder C:\Tasks
			
		.EXAMPLE
			Export-ScheduledTask -TaskName "Proxy"	-Path "\Microsoft\Windows\Autochk"
			
			Exports the task Proxy in the subfolder location \Microsoft\Windows\Autochk from the local computer to the user's Documents folder
			with a name of Proxy.xml
			
		.EXAMPLE
			Get-ScheduledTasks | Where {$_.Name -like "*Office*"} | Export-ScheduledTask
			
			Exports each and every scheduled task that has Office in the name on the local computer to the user's Documents folder.
			This works cause Get-ScheduledTasks creates an object that has a taskname listed under its Name property, it has a Path property, and it has
			a computername property.
			
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
		[string]$Path = '\',
		[Parameter(Mandatory=$False)]
		[string]$Destination = "$($env:userprofile)\Documents"
	)
	Begin
	{
		Write-Verbose "Creating Schedule Service COM Object"
		$sch = New-Object -ComObject("Schedule.Service")	
	}
	Process 
	{
		Write-Verbose "Connecting to computer"
		$sch.Connect($ComputerName)
		Write-Verbose "Exporting xml file of $TaskName"
		$folder = $sch.GetFolder($Path).GetTask($TaskName).Xml | Out-File "$($Destination)\$($TaskName).xml"
	}
	End
	{
		Write-Verbose "Releasing and removing the COM object"
		[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sch) | Out-Null
		Remove-Variable sch
	}
}