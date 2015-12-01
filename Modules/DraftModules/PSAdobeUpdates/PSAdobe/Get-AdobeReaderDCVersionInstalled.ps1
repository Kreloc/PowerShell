Function Get-AdobeReaderDCVersionInstalled
{
	<#	
		.SYNOPSIS
			Finds the version of Adobe Reader DC installed on specified computer.
		
		.DESCRIPTION
			Finds the version of Adobe Reader DC installed on specified computer. Requires admin shares to be available. Target computer must be on and connected to the network.
		
		.PARAMETER ComputerName
			The computer to find the version of Adobe Reader DC installed. Defaults to the computer running the function.
		
		.EXAMPLE
			Get-AdobeReaderDCVersionInstalled
			
			Gets the current version of Adobe Reader DC installed on the current computer.
			
		.EXAMPLE
			Get-Content computers.txt | Get-AdobeReaderDCVersionInstalled
		
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
			Write-Verbose "Attempting to get Adobe Reader DC version."
			$AdobeReaderDC = Get-ChildItem "\\$ComputerName\c$\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" -ErrorAction Stop
			#"Adobe Reader DC version installed is $($AdobeReaderDC.VersionInfo.ProductVersion)"
            Write-Verbose "Running regex and then string manipulation to get version to output the same as on the Adobe website"
            $regex = ".*\."
            $DCversion = [regex]::matches($AdobeReaderDCVersion, $regex, "IgnoreCase")
            $versionOut = $DCversions.Value.TrimEnd('.')
            $splitVersion = $versionOut -split '(\.)'
            $splitVersion[2] = ((($versionOut -split '(\.)')[2]).Insert(0,0)).Insert(0,0)
            $AdobeReaderDCVersion = $splitVersion -join ""
		}
		catch
		{
			Write-Error "Adobe Reader DC was not found at the expected installation location."
			$AdobeReaderDCVersion = "Not Installed"
		}
		Write-Verbose "Returning custom object that can be compared against the online version output."
        New-Object -TypeName PSOBject -Property @{AdobeReaderDCVersion=$AdobeReaderDCVersion
													ComputerName=$ComputerName
		}
    }
}