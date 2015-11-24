<#Function is broken. NASA changed their API access. Needs to be reworked.
Function Get-NASAInfo
{
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Product')]$query				
	)	
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		$url = "http://data.nasa.gov/api/get_search_results/?search=$query"
		$jsonData = $webclient.downloadstring($url)
		$nasa = ConvertFrom-Json $jsonData
		ForEach($post in $nasa.posts)
		{
			$props = [ordered]@{Title=$post.title_plain
								Link=$post.url
								Excerpt=$post.excerpt
								Date=$post.date
								Modified=$post.modified							
		}
          $outputData = New-Object -TypeName PSObject -Property $props
		  $outPutData	
		}
	}
	end{}
}
#>