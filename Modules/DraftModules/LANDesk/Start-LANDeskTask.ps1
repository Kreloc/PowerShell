Function Start-LANDeskTask
{
	<#	
		.SYNOPSIS
			The Start-LANDeskTask function starts the specified LANDesk Scheduled Task.
		
		.DESCRIPTION
			The Start-LANDeskTask function starts the specified LANDesk Scheduled Task and returns the results using the Webservice object.
		
		.PARAMETER ID
			The Task ID of the LANDesk Scheduled Task to be started.

		.EXAMPLE
			Start-LANDeskTask 877
			
			Starts the LANDesk Scheduled Task with an ID of 877. (LAAWorkStationAgent)
			
		.EXAMPLE
			Start-LANDeskQuery "Inventory Scanner Version" | Add-LANDeskComputerToScheduledTask -Id 877
			Start-LANDeskTask 877
			
			This example first gets the results of the Inventory Scanner Version query, which finds computers with the old agent version and then pipes those
			results to Add-LANDeskComputerToScheduledTask, which adds all of the computers found by the query to the Scheduled Task.
			Finally, the scheduled task is started by the Start-LANDeskTask function.
			
		.EXAMPLE
			$oldVersionInstalled = Start-LANDeskQuery "Inventory Scanner Version"
			$oldVersionInstalled[0..19] | Add-LANDeskComputerToScheduledTask -Id 877
			Start-LANDeskTask 877
			
			This example first gets the results of the Inventory Scanner Version query, which finds computers with the old agent version and then stores those
			results in the variable $oldVersionInstallaed. Then, the first twenty computers returned are piped to Add-LANDeskComputerToScheduledTask, which adds those computers to the Scheduled Task.
			Finally, the scheduled task is started by the Start-LANDeskTask function.
			
		.EXAMPLE
			$i=0
			$n = 20
			$OldVersionInstalled = Start-LANDeskQuery -QueryName "Inventory Scanner Version"
			$OnlineOldVersionInstalled = $OldVersionInstalled | Invoke-Ping -Quiet
			$OnlineOldVersionInstalled > .\OnlineOldVersionInstalled.txt
			
			Do
			{
				$Group = $OnlineOldVersionInstalled[$i..$n]
				$Group > ".\LANDeskAgentUpdates\Group$($i)to$($n).txt"
				$Group | Add-LANDeskComputerToScheduledTask -ID 877
				Start-LANDeskTask -ID 877
				$i=$n+1
				$n=$n+21
				$res = $null
				$ComputerCount = $null
				Do
				{
				    $res = Get-LANDeskTaskStatus -ID 877
				    $ComputerCount = $res.CompletedTargetCount + $res.FailedTargetCount
				    $res
				    Start-Sleep 60
				}
				Until($res.AllTargetCount -eq $ComputerCount)
				(Get-LANDeskTaskMachineStatus -ID 877 | Where {$_.Status -like "Failed"} | Select -ExpandProperty Name) | Out-File .\Failed.txt -Append -NoClobber
				$Group | Remove-LANDeskComputerFromScheduledTask -ID 877
			}
			Until($i -gt $OnlineOldVersionInstalled.Count)
			
			This example sets up a loop for automating the deployment of the current WorkStation Agent. 
			First, it creates two counting variables, $i and $n. 
			Second, it stores the results of the query "Inventory Scanner Version" in the variable $OldVersionInstalled. 
			Third, it stores the result of piping those computer names to Invoke-Ping (an external Advanced Function not in this module, but included
			in my ToolKit module). Those computernames are then outputted to a text file. 
			Fourth, it starts going through the Do Until loops to process twenty one machines at a time into the actual Scheduled Task with an ID
			of 877. It outputs each group of comptuernames into a text file. Then it adds those computers to the Scheduled Task with an ID of 877.
			It then starts the scheduled task with an ID of 877. It also increases the values of the counters $i and $n at this time.
			
			Fifth, it goes through the second Do Until loop to check until the task has been run against all of the machines added to it. It does this 
			by getting the computer counts of the scheduled task using Get-LANDeskTaskStatus. It continues to check until the amount of failed and completed target counts
			are equal to the AllTargetCount. It checks the status of the task every minute.
			
			Sixth, it gets the names of the computers that failed the task and outputs them to a text file.
			Seventh, it removes the computers that were added to the scheduled task from it.
			Finally, it loops thru this process until the $i counter is larger than the count of computers in the $OnlineOldVersionInstalled variable. 
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
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
		$LANDeskWebService.StartTaskNow($ID,"Now")
	}
	End{}
}