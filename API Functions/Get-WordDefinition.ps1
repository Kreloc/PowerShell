Function Get-WordDefinition
{
		<#	
		.SYNOPSIS
			Gets a definition for word from onelook.com's api.
		
		.DESCRIPTION
			Get-Definition retrieves a definition for the word from onelook.com's api.
		
		.PARAMETER word
			The word parameter sets the value for the word to be defined when calling the API.
		
		.EXAMPLE
			Get-WordDefinition -word "Sword"
			Retrives the defintion for the word sword from Onelook and lists a phrase with that word, along with links for more resources on that word.
		.EXAMPLE
			Get-Content wordlist.txt | Get-WordDefinition
			Retrives the definition for each word in worldlist.txt.

	#>
    param
    (
        [Parameter(Position=0, Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelinebyPropertyName=$true)][Alias('Query')]$word		
	)	
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		$url = "http://www.onelook.com/?w=$word&xml=1"
		[xml]$xmlData = $webclient.downloadstring($url)
		$result = $xmlData.OLResponse
		$definition = ($result | Select -ExpandProperty OLQuickDef) -join " "
		$props = [ordered]@{Word=$word
							Definition=$definition
							Phrases=$result.OLPhrases
							Websites=$result.OLRes.OLResName
							Links=$result.OLRes.OLResLink
										}
          $outputData = New-Object -TypeName PSObject -Property $props
		  $outPutData											
	}
	end
	{
    	$webclient.Dispose()			
	}		
}	