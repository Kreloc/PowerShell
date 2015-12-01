Function Get-LANDeskDistributionPackage 
{
	<#	
		.SYNOPSIS
			The Get-LANDeskDistributionPackage function returns a list of Distribution packages on the LANDesk Core Server.
		
		.DESCRIPTION
			The Get-LANDeskDistributionPackage function returns a list of Distribution packages on the LANDesk Core Server.

		.EXAMPLE
			Get-LANDeskDistributionPackage
			
			Returns a list of LANDesk distribution packages.
			
		.EXAMPLE
			Get-LANDeskDistributionPackage | Where {$_.PackageName -notlike "*My distribution*"}
			
			Returns only the distribution packages that aren't like My distribution in the package name.
						
		.NOTES
			Working on finding an actual use for this information
			
	#>
	Begin
	{
		If(!($LANDeskWebService))
		{
			Write-Error "Please run Connect-LANDeskServer. This function cannot be performed without an active connection to the LANDesk Web Service."
			Break
		}		
	}
	Process 
	{
		$LANDeskPackages = $LANDeskWebService.ListDistributionPackages("").DistributionPackages
		$LANDeskPackages
	}
	End{}
}