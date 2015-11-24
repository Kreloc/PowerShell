Function Get-PrivateBuild 
{
	<#	
		.SYNOPSIS
			A brief description of the Get-PrivateBuild function.
		
		.DESCRIPTION
			A detailed description of the Get-PrivateBuild function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
		
		.EXAMPLE
			Get-PrivateBuild <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Get-Content computers.txt | Get-PrivateBuild
		
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
		[string]$Path
	)
	Begin
	{
		If(!(Test-Path($Path)))
		{
			$exit = $true
			"Program is not located at supplied path. Exiting."
		}
	}
	Process 
	{
			#Do Stuff
			#If stuff can't create object on its own, create one.
			#Use either if order doesn't matter. PS Version 2. Version 3 and up, can add [sorted] before $props.
			#$props = @{ComputerName=$ComputerName}
			#$Computers = New-Object –TypeName PSObject –Property $props
			#$Computer | Add-Member -MemberType NoteProperty -Name ComputerName -Value $ComputerName
			#$Computers
			Get-Date
	}
	End{}
}