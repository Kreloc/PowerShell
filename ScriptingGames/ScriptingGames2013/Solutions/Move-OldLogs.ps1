Function Move-OldLogs
{
	<#	
		.SYNOPSIS
			The Move-OldLogs function moves log files older than the specified time.
		
		.DESCRIPTION
			The Move-OldLogs function moves log files older than the specified time which
			uses a deault value of 90 days.
		
		.PARAMETER Source
			This parameter determines the folder location to look for log files in.
			
		.PARAMETER Destination
			This parameter determines where the old log files are to be moved to.
			
		.PARAMETER DaysOld
			This parameter sets how old the log files need to be to be moved.
		
		.EXAMPLE
			Move-OldLogs -Source "C:\Application\Log\" -Destination "\\NAS\Archives\"
			
			This will move all of the log files from C:\Application\Log that are older than 90 days
			to the NAS Archives folder.
			
		.EXAMPLE
			Move-OldLogs -Source "C:\Application\Log\" -Destination "\\NAS\Archives\" -DaysOld 30
			
			This will move all of the log files from C:\Application\Log that are older than 30 days
			to the NAS Archives folder.
			
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Source,
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Destination,
		[Parameter(ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[int]$DaysOld = 90					
	)
	Begin
	{
		$files = Get-ChildItem -Filter "*.log" -Path $Source -Recurse
	}
	Process 
	{
		$LogsToMove = $files | Where-Object {$_.LastWriteTime -le (Get-Date).AddDays(-$DaysOld)}
		ForEach($LogToMove in $LogsToMove)
		{
			$DestinationFolder = ($LogToMove.DirectoryName).Replace("$Source","$Destination")
			If(!(Test-Path($DestinationFolder)))
			{
				New-Item -Path $DestinationFolder -ItemType Directory
			}
			Move-Item -Path "$($LogToMove.FullName)" -Destination "$($DestinationFolder)\$($LogToMove.Name)"
		}
	}
	End{}
}