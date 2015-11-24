Function Get-ComputerName 
{
	<#	
		.SYNOPSIS
			This function returns a computername based on given IP Address.
		
		.DESCRIPTION
			This function returns a computername based on given IP Address and exports both sucessful attempts and failurs to a csv file.
		
		.PARAMETER IPAddress
			The IPAddres to get a computername from. 
		
		.EXAMPLE
			Get-ComputerName -IPAddress 127.0.0.1
			
			This will get the local computername from Test-Connection.
			
		.EXAMPLE
			Get-Content ipaddresses.txt | Get-ComputerName
		
			This will get the local computername from each of the ipaddress in the text file.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$IPAddress	
	)
	Begin{}
	Process 
	{
		$ComputerName = Test-Connection -ComputerName $IPAddress -Count 1 -ErrorAction SilentlyContinue | Select -ExpandProperty __Server
		$props = @{
			IPAddres=$IPAddress
			ComputerName=$ComputerName
		}
		$Computers = New-Object -TypeName PSObject -Property $props
		$Computers | Export-CSV -NoTypeInformation .\computers.csv
		$Computers
	}
	End{}
}