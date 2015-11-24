Function Get-PANReport 
{
	<#	
		.SYNOPSIS
			A brief description of the Get-PANReport function.
		
		.DESCRIPTION
			A detailed description of the Get-PANReport function.
		
		.PARAMETER ReportName
			A description of the ComputerName parameter.
			
		.PARAMETER ReportType
			Options for this parameter are "predefined","dynamic", and "custom"
			
		.PARAMETER ReportPeriod
			Use only when dynamic is selected as ReportType. Options for this parameter are
			last-60-seconds,last-15-minutes,last-hour,last-12-hrs,last-24-hrs,last-calendar-day,last-7-days,last-7-calendar-days,last-calendar-week,last-30-days


		.EXAMPLE
			Get-PANReport -ReportName
			
			Explanation of this example
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ReportName,
		[Parameter(Mandatory=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ReportType,
		[Parameter(Mandatory=$False, ValueFromPipelinebyPropertyName=$true)]
		[string]$ReportPeriod
	)
	Begin
	{
		If(!($PaConnectionArray))
		{
			Write-Error "Please run Connect-xmlAPI before running this function. This function requires an API key retrieved by that function."
			Break
		}
		$WebClient = New-Object System.Net.WebClient
		$panRootAddress = $PaConnectionArray | Select -ExpandProperty Address
	}
	Process 
	{
		$url = "https://$($panRootAddress)/api/?type=report&reporttype=$($ReportType)&reportname=$($ReportName)&key=$($PaConnectionArray.APIKey)"
		[xml]$report = $WebClient.DownloadString($url)
		$report 
	}
	End{}
}