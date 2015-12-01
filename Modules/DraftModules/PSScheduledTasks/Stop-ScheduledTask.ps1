Function Stop-ScheduledTask 
{
	<#	
		.SYNOPSIS
			A brief description of the Stop-ScheduledTask function.
		
		.DESCRIPTION
			A detailed description of the Stop-ScheduledTask function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			Stop-ScheduledTask <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Stop-ScheduledTask
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
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
		$folder = $sch.GetFolder($Path).GetTask($TaskName).Stop(0)
	}
	End
	{
		[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sch) | Out-Null
		Remove-Variable sch
	}
}