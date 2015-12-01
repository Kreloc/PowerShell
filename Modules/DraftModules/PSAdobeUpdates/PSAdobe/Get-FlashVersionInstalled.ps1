Function Get-FlashVersionInstalled
{
	<#	
		.SYNOPSIS
			Finds the version of Flash installed on specified computer.
		
		.DESCRIPTION
			Finds the version of Flash installed on specified computer. Requires admin shares to be available. Target computer must be on and connected to the network.
		
		.PARAMETER ComputerName
			The computer to find the version of Flash installed. Will default to the computer running the function.
		
		.EXAMPLE
			Get-FlashVersionInstalled
			
			Gets the current version of Flash ActiveX and Flash Plugin installed on the current computer.
			
		.EXAMPLE
			Get-Content computers.txt | Get-FlashVer
		
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
			Write-Verbose "Attempting to get Flash ActiveX version."
			$FlashInstalled = Get-ChildItem "\\$ComputerName\c$\Windows\System32\Macromed\Flash\" -Filter "*.exe" -ErrorAction Stop
		}
		catch
		{
			Write-Error "Did not find any executables at the installation location for flash"
			$flashActiveXVersionProp = "Not Installed"
			$FlashPluginVersionProp = "Not Installed"						
			
		}
		try
		{
			$FlashActiveX = Get-ChildItem ($FlashInstalled | Where {$_.Name -like "*Active*"}).FullName -ErrorAction Stop
			$ActiveXVersion = $FlashActiveX.VersionInfo
			$flashActiveXVersionProp = ($ActiveXVersion.FileVersion.replace(",",'.'))
		}
		catch
		{
			Write-Error "Did not find the expected executable at the installation location for Flash ActiveX"
			$flashActiveXVersionProp = "Not Installed"
		}
		try
		{
			$FlashPlugin = Get-ChildItem ($FlashInstalled | Where {$_.Name -like "*Plugin*"}).FullName -ErrorAction Stop
			$PluginVersion = $FlashPlugin.VersionInfo
			$FlashPluginVersionProp = ($PluginVersion.FileVersion.replace(",",'.'))
		}
		catch
		{
			$FlashPluginVersionProp = "Not Installed"
		}
		$props = @{FlashActiveXVersion=$flashActiveXVersionProp
					FlashPluginVersion=$FlashPluginVersionProp
					ComputerName=$ComputerName
		}
			New-Object -TypeName PSOBject -Property $props

	}
}