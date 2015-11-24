Function Get-LANDeskColumnSetColumns 
{
	<#	
		.SYNOPSIS
			The Get-LANDeskColumnSetColumns function returns a list of available Column sets.
		
		.DESCRIPTION
			The Get-LANDeskColumnSetColumns function returns a list of available Column sets. This can be used to determine the columns available to each set.
		
		.PARAMETER ID
			The ID of the task to check the status on.

		.EXAMPLE
			Get-LANDeskColumnSetColumns 
			
			Returns a list of available column sets.
						
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipelinebyPropertyName=$true)]
		[alias("ColumnSetName")]
		[string]$Name
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
		$LANDeskWebService.ListColumnSetColumns($Name).Columns
	}
	End{}
}
