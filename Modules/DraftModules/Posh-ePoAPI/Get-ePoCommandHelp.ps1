Function Get-ePoCommandHelp 
{
	<#	
		.SYNOPSIS
			This returns the help for the specified command made available by the API.
		
		.DESCRIPTION
			A detailed description of the Get-ePoCommandHelp function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			Get-ePoCommandHelp <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Get-ePoCommandHelp
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Command	
	)
	Begin{}
	Process 
	{
		$url = "$($epoServer)/remote/core.help?command=$($Command)&:output=xml"
		[xml](($wc.DownloadString($url)) -replace "OK:`r`n") | Select -ExpandProperty Result
	}
	End{}
}