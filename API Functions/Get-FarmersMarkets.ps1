Function Get-FarmersMarkets
{
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Zipcode')]$zip,
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Latitude')]$lat,
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Longitude')]$lng		
	)	
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		If($zip)
		{
			$url = "http://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch?zip=$zip"			
		}
		else
		{
			$url = "http://search.ams.usda.gov/farmersmarkets/v1/data.svc/locSearch?lat=$lat&lng=$lng"
		}
		$jsonData = $webclient.downloadstring($url)
		$markets = ConvertFrom-Json $jsonData
		$marketsids = $markets.results	
		ForEach($id in $marketsids)
		{
			$name = ($id.marketname -replace "^[^ ]*") -replace "^ "
			$distance = ($id.marketname -split " ")[0] 
			$urltwo = "http://search.ams.usda.gov/farmersmarkets/v1/data.svc/mktDetail?id=$($id.id)"
			$details = $webclient.downloadstring($urltwo)
			$detail = ConvertFrom-Json $details
			$props = [ordered]@{Name=$name
								Address=$detail.marketdetails.address
								Distance=$distance
								GoogleLink=$detail.marketdetails.GoogleLink
								Products=$detail.marketdetails.Products
								Schedule=($detail.marketdetails.Schedule) -replace ";.*"
			}
          $outputData = New-Object -TypeName PSObject -Property $props
		  $outPutData					
		}
	}
	end
	{
	}	
}