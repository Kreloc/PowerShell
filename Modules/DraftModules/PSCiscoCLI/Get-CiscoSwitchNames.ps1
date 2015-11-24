Function Get-CiscoSwitchNames 
{
	<#	
		.SYNOPSIS
			A brief description of the Get-CiscoSwitchNames function.
		
		.DESCRIPTION
			A detailed description of the Get-CiscoSwitchNames function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			Get-CiscoSwitchNames <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Get-CiscoSwitchNames
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
		.NOTES
			Right now only supports csv file import. Want to implement ability to create the object of switch names and IP Addresses within the function.	
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Path	
	)
	Begin{}
	Process 
	{
		$Switches = Import-CSV $Path | Where {$_.SwitchLogicalName -notlike ""}
		$Switches
	}
	End{}
}