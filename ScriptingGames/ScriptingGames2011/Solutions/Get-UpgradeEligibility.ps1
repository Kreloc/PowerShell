Function Get-UpgradeEligibility 
{
	<#	
		.SYNOPSIS
			This function determines if a computer can have Windows 10 installed.
		
		.DESCRIPTION
			This function determines if a computer can have Windows 10 installed. Uses WMI.
		
		.PARAMETER ComputerName
			The name of the computer to retrieve the information from. If no name is given, the local machine is used.
		
		.EXAMPLE
			Get-UpgradeEligibility <ComputerName>
			
			Gets the upgrade eligibility for the specified computer.
			
		.EXAMPLE
			Get-Content computers.txt | Get-UpgradeEligibility
		
			Gets the upgrade eligibility for each the specified computers in the computers.txt file.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName = $Env:COMPUTERNAME
	)
	Begin
	{
		$ping = Test-Connection -ComputerName $ComputerName -Count 1 -Quiet
	}
	Process 
	{
		#Gather WMI information for the necessary specs.
		$Processor = Get-WMIObject Win32_Processor -ComputerName $ComputerName | Select MaxClockSpeed, DataWidth
		$Ram = Get-WMIObject Win32_ComputerSystem -ComputerName $ComputerName | Select TotalPhysicalMemory, SystemType
		
		
		If(!($ping)){"Logic:Output computername to failed to reach text file log or something."}
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