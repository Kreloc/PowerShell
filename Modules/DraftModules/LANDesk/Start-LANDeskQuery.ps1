Function Start-LANDeskQuery
{
	<#	
		.SYNOPSIS
			The Start-LANDeskQuery function runs the specified LANDesk query and returns the results.
		
		.DESCRIPTION
			The Start-LANDeskQuery function runs the specified LANDesk query and returns the results using the Webservice object.
		
		.PARAMETER QueryName
			The name of the query to run.

		.EXAMPLE
			Start-LANDeskQuery "NewQuery"
			
			Runs the NewQuery query and returns the results.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$QueryName	
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
		$queryResults = $LANDeskWebService.RunQuery("$QueryName")
		$queryDevicesReturned = ForEach($QueryResult in $queryResults.tables[0].rows)
		{
			$QueryResult
		}
		$queryDevicesReturned		
	}
	End{}
}