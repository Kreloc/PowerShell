Function Disable-ScheduledTask 
{
	<#	
		.SYNOPSIS
			Disable-ScheduledTask disables the specified task by name either on the local computer or a remote computer.
		
		.DESCRIPTION
			Disable-ScheduledTask disables the specified task by name either on the local computer or a remote computer. Uses
			the Schedule.Service COM object.
		
		.PARAMETER ComputerName
			The name of the remote computer to disable a task on. If parameter isn't specified, the local computer is used.
			
		.PARAMETER TaskName
			The name of the task to be disabled.
			
		.PARAMETER Path
			The path the task exists in. If parameter isn't specified, the root path, \, is used.	

		.EXAMPLE
			Disable-ScheduledTask -Task "Scheduled Task Demo"
			
			Disables the task with a name of Scheduled Task Demo on the local computer.
			
		.EXAMPLE
			Disabled-ScheduledTask -Task "Scheduled Task Demo" -ComputerName "THATPC" -Path "\DemoFolder\"
		
			Disables the task with a name of Scheduled Task Demo in the \DemoFolder\ location on the remote computer named THATPC.
			
		.NOTES
			Must be run as administrator. Uses the Test-ForAdmin function to determine if running as administrator already.
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
		Write-Verbose "Testing if powershell is being run as Administrator"
		If(Test-ForAdmin)
		{
			Write-Verbose "Creating Schedule.Service COM object"
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
		Write-Verbose "Connecting to schedule service"
		$sch.Connect($ComputerName)
		Write-Verbose "Disabling the task"
		$folder = $sch.GetFolder($Path).GetTask($TaskName).Enabled = $False
	}
	End
	{
		[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sch) | Out-Null
		Remove-Variable sch
	}
}