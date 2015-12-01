Function Get-ScheduledTasks 
{
	<#	
		.SYNOPSIS
			Get-ScheduledTasks retrieves all of the scheduled tasks on the local computer or a remote computer if a name is supplied to 
			the ComputerName parameter.
		
		.DESCRIPTION
			Get-ScheduledTasks retrieves all of the scheduled tasks on the local computer or a remote computer if a name is supplied to 
			the ComputerName parameter. Uses the Schedule.Service COM object and its methods to retrieve these tasks.
		
		.PARAMETER ComputerName
			The name of the computer to connect to. If this parameter isn't specified, the local computer is used.

		.EXAMPLE
			Get-ScheduledTasks
			
			Gets all of the scheduled tasks on the local computer.
			
		.EXAMPLE
			Get-ScheduledTasks -ComputerName "THATPC"
		
			Gets all of the scheduled tasks on the remote computer named THATPC.
			
		.EXAMPLE
			Get-ScheduledTasks | Where {$_.Name -like "*Adobe*"}
			
			Returns only tasks that have Adobe in the name on the local computer.
			
		.EXAMPLE
			$Alltasks = Import-CSV .\computers.csv | Get-ScheduledTasks
			
			Gets all of the scheduledtasks for each of the computers listed by named under
			a ComputerName header in the computers.csv file.
			
		.EXAMPLE
			Get-ScheduledTasks | Where {$_.Name -like "*Adobe*"} | Export-ScheduledTask
			
			Exports all of the tasks with Adobe in the name on the local computer to the
			user's documents folder.		
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName = ""
	)
	Begin
	{
		Write-Verbose "Creating Schedule Service COM object"
		$sch = New-Object -ComObject("Schedule.Service")
		Function getTasks($path) 
		{
    		$out = @()
		    # Get root tasks
    		$sch.GetFolder($path).GetTasks(0) | ForEach-Object {
	        	$xml = [xml]$_.xml
	        	$out += New-Object psobject -Property @{
	            "Name" = $_.Name
	            "Path" = $_.Path.Replace("$($_.Name)","")
	            "LastRunTime" = $_.LastRunTime
	            "NextRunTime" = $_.NextRunTime
	            "Actions" = ($xml.Task.Actions.Exec | % { "$($_.Command) $($_.Arguments)" }) -join "`n"
		 		"Definition" = $_.Definition
				"Enabled" = $_.Enabled 
				"LastTaskResult" = $_.LastTaskResult
				"NumberOfMissedRuns" = $_.NumberOfMissedRuns
				"State" = $_.State
				"XML" = $_.xml
				"ComputerName" = $ComputerName
		 #Definition, Enabled, LastRunTime, LastTaskResult, NextRunTime, NumberOfMissedRuns, Path, State, XML, $ComputerName       
				}
		    }
		
		    # Get tasks from subfolders
		    $sch.GetFolder($path).GetFolders(0) | ForEach-Object {
		        $out += getTasks($_.Path)
		    }
		
		    #Output
		    $out
		}
	}
	Process 
	{
			Write-Verbose "Connecting to scheduled task service on $ComputerName"
			$sch.Connect($ComputerName)
			$tasks = @()
			$tasks += getTasks("\")
			$tasks
	}
	End
	{
		[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sch) | Out-Null
		Remove-Variable sch
	}
}