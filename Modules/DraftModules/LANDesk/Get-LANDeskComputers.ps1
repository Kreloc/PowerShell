<#Deprecated
Replaced all functionally within the Get-LANDeskComputer function
Function Get-LANDeskComputers
{
	<#	
		.SYNOPSIS
			The Get-LANDeskComputers function gets all of the machines listed in LanDesk and stores them in a global variable.
		
		.DESCRIPTION
			The Get-LANDeskComputers function gets all of the machines listed in LanDesk and stores them in a global variable using the ListMachines method of the Web Service object.
            The computers are stored in a global variable as the GUID of each computer returned from this is needed for other functions.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			Get-LANDeskComputers
			
			Returns all of the computers currently in LanDesk and stores them in a variable for use in other functions in the PSLANDeskModule.
			
	#>
<#
    $global:LANDeskComputers = $LANDeskWebService.ListMachines("").Devices | Select GUID, @{name="ComputerName";expression={$_.DeviceName}}, DomainName, LastLogin, IPAddress, SubnetMask, MACAddress, OSName
    $LANDeskComputers
}
#>