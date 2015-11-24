Function Get-Blank 
{
	<#	
		.SYNOPSIS
			A brief description of the Get-Blank function.
		
		.DESCRIPTION
			A detailed description of the Get-Blank function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
		
		.EXAMPLE
			PS C:\> Get-Blank <ComputerName>
			
		.EXAMPLE
			Get-Content computers.txt | Get-Blank
		
		.NOTES
			Additional information about the function.
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName	
	)
	PROCESS 
	{
			#Do Stuff
			#If stuff can't create object on its own, create one.
			#$props = @{ComputerName=$ComputerName
						Date=(Get-Date)
			#$Computers = New-Object –TypeName PSObject –Property $props
			#$Computers
	}
}