Function New-TempTextFile 
{
	<#	
		.SYNOPSIS
			Creates a temporary text file in the temporary folder.
		
		.DESCRIPTION
			Creates a temporary text file in the temporary folder and outputs the path to that file.
			If the -Open parameter is used, the newly created file will open in Notepad. If the -Encoding parameter
			is used, the file encoding type can be set, such as ASCII or Unicode.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
		
		.EXAMPLE
			New-TempTextFile <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Get-Content computers.txt | New-TempTextFile
		
			Explanation of this example.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName	
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
			Get-Date
	}
	End{}
}