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
			Get-Blank <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Get-Blank
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName")]
		[string]$ComputerName	
	)
	Begin{}
	Process 
	{
			#Do Stuff
			#If stuff can't create object on its own, create one.
			#Use either if order doesn't matter. PS Version 2. Version 3 and up, can add [sorted] before $props.
			#$props = @{ComputerName=$ComputerName}
			#$Computers = New-Object -TypeName PSObject -Property $props
			#$Computer | Add-Member -MemberType NoteProperty -Name ComputerName -Value $ComputerName
			#$Computers
			#$Object | Select @{name="PC";expression={$_.__Server}}
			Write-Verbose "Getting today's date"
			Get-Date
	}
	End{}
}