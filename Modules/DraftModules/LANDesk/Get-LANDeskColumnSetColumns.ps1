Function Get-LANDeskColumnSetColumns 
{
	<#	
		.SYNOPSIS
			The Get-LANDeskColumnSetColumns function returns a list of available Column sets.
		
		.DESCRIPTION
			The Get-LANDeskColumnSetColumns function returns a list of available Column sets. This can be used to determine the columns available to each set.
		
		.PARAMETER Name
			The Name of the ColumnSet to retrieve the columns from.

		.EXAMPLE
			Get-LANDeskColumnSetColumns -ColumnSetName "Mark"
			
			Returns a list of available columns in the column set named Mark.
						
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
