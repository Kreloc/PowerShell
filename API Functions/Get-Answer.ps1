Function Get-Answer
{
		<#	
		.SYNOPSIS
			Get-Answer gets the Instant Answer from DuckDuckGo for the entered query.
		
		.DESCRIPTION
			Get-Answer gets the Instant Answer from DuckDuckGo for the entered query using
			DuckDuckGo's API and returns information about that answer.
		
		.PARAMETER query
			The query parameter sets the value that should be used when calling the API.
		
		.EXAMPLE
			Get-Answer "What is Google?"
			Will reutrn the Heading, Image Url, AbstractText, URL, and Source for the answer to the question.
		.EXAMPLE
			Get-Answer "What is Warhammer Fantasy Roleplaying?"
			Will output that the question could not be answered.		
	#>
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Search')]$query				
	)	
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		$url = "http://api.duckduckgo.com/?q=$query&format=json"
		$jsonData = $webclient.downloadstring($url)
		$results = ConvertFrom-JSON $jsonData
		If($results.Heading -like "")
		{
			Write-Output "Did not find an answer for $query."
		}
		else
		{
			$results | Select Heading, Image, AbstractText, AbstractURL, AbstractSource			
		}
	}
	end
	{
		$webclient.Dispose()
	}		
}