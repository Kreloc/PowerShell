Function Get-AdobeReaderDCVersionOnline 
{
	<#	
		.SYNOPSIS
			A brief description of the Get-AdobeReaderDCVersionOnline function.
		
		.DESCRIPTION
			A detailed description of the Get-AdobeReaderDCVersionOnline function.
		
		.PARAMETER Uri
			The webaddress to find the adobe product information on. Currently goes to Adobe's release notes by default

		.EXAMPLE
			Get-AdobeReaderDCVersionOnline
			
			Returns the current version of AdobeReader DC from adobe's website
			
		.NOTES
			Function relies on web scraping and could break if website changes too much.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,ValueFromPipelinebyPropertyName=$true)]
		[alias("Url")]
		[string]$Uri = "https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotes/index.html"
	)
	Begin{}
	Process 
	{
		$AdobeWebPage = Invoke-WebRequest -Uri $Uri
		$Links = $AdobeWebPage.Links
		$group = $links | Where {$_.href -like "*dccontinuous*" -and $_.innerText -like "*update*"} | Select @{Name="Adobe Reader DC Version";expression={$_.outerText}}, @{Name="Relase Date";Expression={Get-Date((((((($_.outerText  -split "Update,")[-1]).TrimStart())) -split " ")[0..2]) -join " ")}}
		ForEach($Version in $group.'Adobe Reader DC Version')
		{
			If($Version -match ':')
			{
				$ReaderDCNewestVersion = (($Version -split ':')[1] -split " ")[1]
			}	
		}
		New-Object -TypeName PSObject -Property @{AdobeReaderDCVersion=$ReaderDCNewestVersion}
	}
	End{}
}