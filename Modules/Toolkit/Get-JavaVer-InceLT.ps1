function Get-JavaVer
{
	<#	
		.SYNOPSIS
			Finds the version of Java installed on specified computer.
		
		.DESCRIPTION
			Finds the version of Java installed on specified computer. Requires admin shares to be available. Target computer must be on and connected to the network.
		
		.PARAMETER ComputerName
			The computer to find the version of Java installed.
		
		.EXAMPLE
			Get-JavaVer -ComputerName "THATPC"
			
		.EXAMPLE
			Get-Content computers.txt | Get-JavaVer
		
		.NOTES
			Requires admin shares.
	#>
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $False,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)][Alias('Name')] 
        $ComputerName = $env:computername
	)	
	PROCESS
	{
		try
		{
			Write-Verbose "Attempting to get Java version."
			$ErrorActionPreference = "Stop"
			$java = gci "\\$ComputerName\c$\Program Files (x86)\Java\jre7\bin\java.exe"
			$java.VersionInfo			
		}
		catch
		{
			Write-Verbose "Someting went wrong."
			$Error[0].Exception >> errors.txt
		}
		finally
		{
			$ErrorActionPreference = "Continue"
		}

	}
}