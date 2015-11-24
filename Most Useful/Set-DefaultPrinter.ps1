Function Set-DefaultPrinter 
{
	<#	
		.SYNOPSIS
			Set-DefaultPrinter lists installed printers and lets you set one as the default printer.		
		.DESCRIPTION
			Set-DefaultPrinter lists installed printers and lets you set one as the default printer.
		
		.PARAMETER ComputerName
			ComputerName of the computer to set the default printer on.
		
		.EXAMPLE
			Set-DefaultPrinter -ComputerName "THATPC"
			
		.EXAMPLE
			Get-Content computers.txt | Set-DefaultPrinter
		
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
	BEGIN
	{
		
	}
	PROCESS 
	{
		$printers = Get-WmiObject Win32_printer -Computername $ComputerName
		$printers
		$choice = Read-Host "Type the printer name you want to be made the default printer."
		($printers | Where {$_.Name -like "$choice"}).SetDefaultPrinter() 
	}
	END
	{
		
	}
}