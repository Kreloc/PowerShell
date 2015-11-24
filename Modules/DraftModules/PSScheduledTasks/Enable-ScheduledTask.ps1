Function Enable-ScheduledTask 
{
	<#	
		.SYNOPSIS
			Enable-ScheduledTask enables a task by name either on the local computer or a remote computer.
		
		.DESCRIPTION
			Enable-ScheduledTask enables a task by name either on the local computer or a remote computer. Uses the Schedule.Service COM object
			and its methods.
		
		.PARAMETER ComputerName
			The name of the computer to enable a task on. If this parameter isn't specified, the local computer will be used.

		.EXAMPLE
			Enable-ScheduledTask -TaskName "ScheduledTask Demo"
			
			Enables the task ScheduledTask Demo on the local computer that is in the \ root location.
			
		.EXAMPLE
			Enable-ScheduledTask -TaskName "ScheduledTask Demo" -Path "\DemoFolder\"
			
			Enables the task ScheduledTask Demo on the local computer that is in the \DemoFolder\ subfolder location.	
			
		.EXAMPLE
			Enable-ScheduledTask -TaskName "ScheduledTask Demo" -Path "\DemoFolder\" -ComputerName "THATPC"
		
			Enables the task ScheduledTask Demo on the remote computer named THATPC that is in the \DemoFolder\ subfolder location.
			
		.EXAMPLE
		 	Get-ScheduledTasks | Where {$_.Enabled -eq $False -and $_.Name -like "*ScheduledTask Demo*"} | Enable-ScheduledTask
			 
			 Enables all of the tasks that are disabled and have ScheduledTask Demo in their name on the local computer.		
			
		.NOTES
			Must be run as Administrator. Uses the included Test-ForAdmin function to check.	
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
		[string]$Path = '\'
	)
	Begin
	{
		If(Test-ForAdmin)
		{
			$sch = New-Object -ComObject("Schedule.Service")
		}
		else
		{
			Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    		Break
		}
	}
	Process 
	{
		$sch.Connect($ComputerName)
		$folder = $sch.GetFolder($Path).GetTask($TaskName).Enabled = $True
	}
	End
	{
		[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sch) | Out-Null
		Remove-Variable sch
	}
}