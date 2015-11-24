Function Get-ShockWaveVersionInstalled
{
	<#	
		.SYNOPSIS
			Finds the version of Shockwave installed on specified computer.
		
		.DESCRIPTION
			Finds the version of Shockwave installed on specified computer. Requires admin shares to be available. Target computer must be on and connected to the network.
		
		.PARAMETER ComputerName
			The computer to find the version of Shockwave installed.
		
		.EXAMPLE
			Get-ShockWaveVersionInstalled
			
			Gets the version of shockwave installed on the computer running the function.
			
		.EXAMPLE
			Get-Content computers.txt | Get-ShockWaveVersionInstalled
		
			Gets the version of shockwave installed on each computer listed in the computer.txt file. 
			
		.NOTES
			Requires admin shares.
	#>
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $False,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)][Alias('Name')] 
        $ComputerName = $env:computername
	)	
	Process
	{
		try
		{
			Write-Verbose "Attempting to get Shockwave version."
			$ShockWave = Get-ChildItem ((Get-ChildItem (Get-ChildItem "\\$ComputerName\c$\Windows\SysWOW64\Adobe" -ErrorAction Stop | Where {$_.Name -like "Shockwave*"}).FullName) | Where {$_.Name -like "dirapi*"}).FullName
			$Version = $ShockWave.VersionInfo.FileVersion -replace "r",'.'
		}
		catch
		{
			Write-Error "Shockwave installation was not found at the expected installation location. \\$ComputerName\c$\Windows\SysWOW64\Adobe"
			$Version = "Not Installed"
		}
		New-Object -TypeName PSObject -Property @{ShockWavePlayerVersion=$Version
												ComputerName=$ComputerName
		}
	}
}