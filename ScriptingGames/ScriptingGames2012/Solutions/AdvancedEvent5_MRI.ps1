Function Get-LogErrors 
{
	<#	
		.SYNOPSIS
			A brief description of the Get-LogErrors function.
		
		.DESCRIPTION
			A detailed description of the Get-LogErrors function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
		
		.EXAMPLE
			Get-LogErrors <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Get-Content computers.txt | Get-LogErrors
		
			Explanation of this example.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName,
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$LogName
	)
	Begin{}
	Process 
	{
			#Do Stuff
			#If stuff can't create object on its own, create one.
			#Use either if order doesn't matter. PS Version 2. Version 3 and up, can add [sorted] before $props.
			#$props = @{ComputerName=$ComputerName}
			#$Computers = New-Object –TypeName PSObject –Property $props
			#$Computer | Add-Member -MemberType NoteProperty -Name ComputerName -Value $ComputerName
			#$Computers
		$ErrorLog = Get-EventLog -LogName $LogName -EntryType Error -ComputerName $ComputerName
		$ErrorLog
	}
	End{}
}