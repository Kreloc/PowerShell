Function Get-FlashVersion
{
	<#	
		.SYNOPSIS
			Finds the version of Flash installed on specified computer.
		
		.DESCRIPTION
			Finds the version of Flash installed on specified computer. Requires admin shares to be available. Target computer must be on and connected to the network.
		
		.PARAMETER ComputerName
			The computer to find the version of Flash installed.
		
		.EXAMPLE
			Get-FlashVer -ComputerName "THATPC"
			
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
			$FlashActiveX = Get-ChildItem ($FlashInstalled | Where {$_.Name -like "*Active*"}).FullName
			$ActiveXVersion = $FlashActiveX.VersionInfo
			$FlashPlugin = Get-ChildItem ($FlashInstalled | Where {$_.Name -like "*Plugin*"}).FullName
			$PluginVersion = $FlashPlugin.VersionInfo
			$props = @{FlashActiveXVersionInstalled=($ActiveXVersion.FileVersion.replace(",",'.'))
						FlashPluginVersionInstalled=($PluginVersion.FileVersion.replace(",",'.'))
						ComputerName=$ComputerName
									}
			New-Object -TypeName PSOBject -Property $props
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