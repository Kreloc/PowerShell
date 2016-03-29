Function Get-ShockwaveOnlineVersion 
{
	<#	
		.SYNOPSIS
			Get-ShockwaveOnlineVersion retrieves the most current version of Shockwave from the web.
		
		.DESCRIPTION
			Get-ShockwaveOnlineVersion retrieves the most current version of Shockwave from the web. Uses Invoke-WebRequest, so requires PowerShell 3 or greater.
		
		.PARAMETER Uri
			The website to gather information about shockwave from. Defaults to adobe's webpage help for shockwave

		.EXAMPLE
			Get-ShockwaveOnlineVersion
			
			Returns the current version of Shockwave from Adobe's website
			
		.NOTES
			Reiles on website information and parsing that information, so it will likely break in the future.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,ValueFromPipelinebyPropertyName=$true)]
		[alias("Url")]
		[string]$Uri = "https://get.adobe.com/shockwave/"
	)
	Begin{}
	Process 
	{
		$Shockwave = Invoke-WebRequest -Uri $Uri
 		<#Below is kind of broken, does report the newest version on that page but that page is not up to date anymore.
        #$uri = "https://helpx.adobe.com/shockwave.html"
        $ShockWaveVersionPage = "https://helpx.adobe.com" + ($Shockwave.Links | Where {$_.outerText -like "Release Notes*"}).href
        $ShockWaveVersion = Invoke-WebRequest -Uri $ShockWaveVersionPage
        $regex = "Shockwave Player.*"
        $ShockWaveVersions = [regex]::matches($ShockWaveVersion, $regex, "IgnoreCase")
		$CurrentVersionUgly = ($ShockwaveVersions | Where {$_.Value -match "\d+" -and $_.Value -like "Shockwave Player*" -and $_.Value -notlike "Shockwave Player 11*" -and $_.Value -match '&nbsp;'} | Sort Index)[0]
		$ShockWaveCurrentVersion = (($CurrentVersionUgly -split '&nbsp;')[1]).replace('<br />',"")
        #>
        $ShockWaveCurrentVersion = ($Shockwave.ParsedHtml.getElementById("autoSelectedVersion").textContent -replace "System.*","") -replace "Version ",""
		New-Object -TypeName PSOBject -Property @{ShockWavePlayerVersion=$ShockWaveCurrentVersion}
	}
	End{}
}