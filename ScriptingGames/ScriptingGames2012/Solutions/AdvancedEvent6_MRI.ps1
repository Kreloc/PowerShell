Function Get-UpTime 
{
	<#	
		.SYNOPSIS
			A brief description of the Get-UpTime function.
		
		.DESCRIPTION
			A detailed description of the Get-UpTime function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
		
		.EXAMPLE
			Get-UpTime <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Get-Content computers.txt | Get-UpTime
		
			Explanation of this example.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName,
		[Parameter]
		[Swtcih]$Export	
	)
	Begin{}
	Process 
	{
			$Date = Get-Date
			$OS = Get-WMIObject -Class Win32_OperatingSystem -ComputerName $ComputerName
			
			$Date - ($os.ConvertToDateTime($os.LastBootUpTime)) | Select @{Name="ComputerName";Expression={"$ComputerName"}}, Days, Hours, Minutes, Seconds, @{Name="Date";Expression={$Date.ToString("M/d/yyyy")}}
			#Export to file process.
			
	}
	End{}
}