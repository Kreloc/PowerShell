Function Get-LANDeskComputer
{
	<#	
		.SYNOPSIS
			The Get-LANDeskComputer function creates the gloabl variable $LANDeskComputers if it doesn't yet exist. This is all of the computers returned by the ListMachines
			method of the LANDesk Web Service object. The function then return output based on whether the Filter or Identity parameter is used. 
		
		.DESCRIPTION
			The Get-LANDeskComputer function creates the gloabl variable $LANDeskComputers if it doesn't yet exist. This is all of the computers returned by the ListMachines
			method of the LANDesk Web Service object. The function then return output based on whether the Filter or Identity parameter is used. Uses Where-Object filtering 
			on the global LANDeskComputers variable. This function retrieves the GUID of each computer which is used in other functions in the LANDesk module.
		
		.PARAMETER Filter
			Specifies a query string that retrieves LANDesk computer objects. This string uses the PowerShell Expression
			Language syntax. The PowerShell Expression Language syntax provides rich type-conversion support for value types
			received by the Filter parameter. The syntax uses an in-order representation, which means that the operator is
			placed between the operand and the value.
			
			Examples:
			The following examples show use to use this syntax with this function.
			
			Get-LANDeskComputer -Filter *
			Returns all LANDeskComputer objects. Ignore this example, still working on getting it to perform correctly.
			Instead just run Get-LANDeskComputer with no paramters to retrieve the same results.
			
			Get-LANDeskComputer -Filter {$_.ComputerName -like "*"}
			
			Returns all LANDeskComputer objects.
			
			Get-LANDeskComputer -Filter {$_.ComputerName -like "LA-LDP*"}
			
			Returns all LANDeskComputer objects that have a computername beginning with LA-LDP
			
			Get-LANDeskComputer -Filter {$_.IPAddress -like "192.168.028*"}
			
			Returns all LANDeskComputer objects that have an IPAddress beginning with 192.168.028 (The 0 is necessary due to how LANDesk stores the IPAddress information.)
			
			Get-LANDeskComputer -Filter {$_.SubNetMask -eq "255.255.248.000"}
			
			Returns all LANDeskComputer objects that have a SubnetMask equal to 255.255.248.000
			
			Get-LANDeskComputer -Filter {$_.LastLogin -eq "ADMINISTRATOR"}
			
			Returns all LANDeskComputer obejcts where the LastLogin value is equal to ADMINISTRATOR
			
			Get-LANDeskComputer -Filter '$_.OSName -notlike "Microsoft Windows 7*"'
			
			Returns all LANDeskComputer objects where the Operating System is not Windows 7

		.EXAMPLE
			Get-LANDeskComputer
			
			Returns all of the computers returned by the ListMachines method of the LANdesk WebService object.
			
		.EXAMPLE
			Get-LANDeskComputer -Identity "$env:computername"
		
			Returns the landesk information for the computer running the function.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False, ValueFromPipelinebyPropertyName=$true,ParameterSetName='Filter')]
		[Scriptblock]$Filter = {$_.ComputerName -like "*"},
		[Parameter(Mandatory=$False,
		ValueFromPipelinebyPropertyName=$true,ParameterSetName='Identity')]
		[Alias('ComputerName',"IPAddress","MACAddress","GUID")]
		[string]$Identity
	)
	Begin
	{
		If(!($LANDeskWebService))
		{
			Write-Error "Please run Connect-LANDeskServer. This function cannot be performed without an active connection to the LANDesk Web Service."
			Break
		}
		If(!($LANDeskComputers))
		{
			 $global:LANDeskComputers = $LANDeskWebService.ListMachines("").Devices | Select GUID, @{name="ComputerName";expression={$_.DeviceName}}, DomainName, LastLogin, IPAddress, SubnetMask, MACAddress, OSName
		}
	}
	Process 
	{
		If($Filter -and (!($Identity)))
		{
			$LANDeskComputers | Where $Filter						
		}
		If($Identity)
		{
			$LANDeskComputers | Where {$_.ComputerName -eq $Identity -or $_.IPAddress -eq $Identity -or $_.MACAddress -eq $Identity -or $_.GUID -eq $Identity}
		}
	}
	End{}
}