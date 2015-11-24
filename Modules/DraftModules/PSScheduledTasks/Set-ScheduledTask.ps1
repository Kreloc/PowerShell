Function Set-ScheduledTask 
{
	<#	
		.SYNOPSIS
			The Set-ScheduledTask function sets all of the scheduled tasks found in the path parameter in xml format to
			the specified computer.
		
		.DESCRIPTION
			The Set-ScheduledTask function sets all of the scheduled tasks found in the path parameter in xml format to
			the specified computer. 
		
		.PARAMETER ComputerName
			The name of the computer to set the scheduled task onto.

		.EXAMPLE
			Set-ScheduledTask "THATPC"
			
			Sets the tasks found in the default location for the Path parameter onto THATPC
			with the user account for the task set to the default of SYSTEM.
			
		.EXAMPLE
			Import-CSV .\computers.csv | Set-ScheduledTask
		
			Sets the tasks found in the default location for the Path parameter onto each computer listed under a 
			ComputerName header in computers.csv with the user account for the task set to the default of SYSTEM.
			
		.EXAMPLE
			Export-ScheduledTask -TaskName "Remote Adobe CC Update"
			Set-ScheduledTask -ComputerName "THATPC" -Path "$($env:userprofile)\Documents"	
			
			The above uses the Export-ScheduledTask to export an xml file from the local computer into the default directory of My Documents.
			Then it uses Set-ScheduledTask to set that task onto THATPC, a remote computer.
			 
		.NOTES
			Requires XML files from exported Scheduled Tasks to function. Due to how the Set-ScheduledTask works, it will try to set all
			of the XML files it finds in the directory provided to the Path parameter as tasks.
			Must be run as Administrator.
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName = "",
		[Parameter(ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Path = ".\Tasks",
		[Parameter(ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$TaskUser = "SYSTEM"
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
		$sch.connect("$ComputerName")
		$folder = $sch.GetFolder("\")
		Get-ChildItem -Path $Path -Filter "*.xml" |
		ForEach-Object {
			$TaskName = $_.Name.Replace('.xml','')
			$TaskXML = Get-Content $_.FullName
			$Task = $sch.NewTask($null)
			$Task.XmlText = $TaskXML
			$folder.RegisterTaskDefinition($TaskName, $Task, 6, $TaskUser, $null, 1, $null)
		}
	}
	End{}
}