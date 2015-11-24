Function New-ScheduledTaskFolder 
{
	<#	
		.SYNOPSIS
			A brief description of the New-ScheduledTaskFolder function.
		
		.DESCRIPTION
			A detailed description of the New-ScheduledTaskFolder function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			New-ScheduledTaskFolder <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | New-ScheduledTaskFolder
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
		.NOTES
			Must be run as Administrator.	
			
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
		[string]$TaskFolder,
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Path = '\'
	)
	Begin
	{
		$sch = New-Object -ComObject("Schedule.Service")	
	}
	Process 
	{
		$sch.Connect($ComputerName)
		$folder = $sch.GetFolder($Path).CreateFolder($TaskFolder)
	}
	End
	{
		[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sch) | Out-Null
		Remove-Variable sch
	}
}