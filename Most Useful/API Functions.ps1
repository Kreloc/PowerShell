<#Preface
These are all APIs that I and others have found that do not currently require API keys to access. My goal as I went along was to gather as many into one place
and use PowerShell to to be able to get and manipulate the data from the various sources. 
#>
Function Start-URL
{
	param
	(
		[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)]$Url
	)
	begin{}
	process{Start-Process $url}
	end{}
}
Function Get-RedditSub
{
	param
	(
		[Parameter(Position=0)]$Sub
	)
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		$url = "http://www.reddit.com/r/$Sub/.json?"
		$jsonData = $webclient.downloadstring($url)
		$reddit = ConvertFrom-Json $jsonData
		$subdata = $reddit.data.children.data
		$subdata | Select Title, SelfText, Author, Score, Url
	}
		end
	{
		$webclient.Dispose()
	}
}
Function Get-NASAInfo
{
		<#	
		.SYNOPSIS
			Get-NASAInfo pulls information from the NASA API available at http://data.nasa.gov/api/
		
		.DESCRIPTION
			A detailed description of the Get-Blank function.
		
		.PARAMETER query
			The query parameter sets the value that should be used when calling the API.
		
		.EXAMPLE
			Get-NASAInfo -query "Moon"
			Retrieves articles on nasa.gov relating to the moon.

	#>
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
	end
	{
		$webclient.Dispose()
	}
}
####
Function Get-ProductRecalls
{
		<#	
		.SYNOPSIS
			Get-ProductRecalls gets information on product recalls from USA.gov's API.
		
		.DESCRIPTION
			Get-ProductRecalls gets information on product recalls from USA.gov's API that match the word entered to search for.
		
		.PARAMETER query
			The query parameter sets the value that should be used when calling the API.
		
		.EXAMPLE
			Get-ProductRecalls "Baby strollers"
			
		.EXAMPLE
			Get-ProductRecalls "Nissan"
		
	#>
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Product')]$query				
	)	
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		$url = "http://api.usa.gov/recalls/search.json?query=$query"
		$jsonData = $webclient.downloadstring($url)
		$recalls = ConvertFrom-Json $jsonData
		$total = $recalls.success.total
		$results = $recalls.success.results
		ForEach($result in $results)
		{
			$props = [ordered]@{Organization=$result.organization
						RecallNumber=$result.Recall_number
						RecallDate=$result.Recall_date
						RecallUrl=$result.Recall_url	
			}			
			If($result.Product_Types)
			{
				$props["Manufacturers"]=$result.manufacturers
				$props["ProductTypes"]=$result.Product_types
				$props["Hazards"]=$result.Hazards
				$props["Countries"]=$result.countries																
			}
			if($result.defect_summary)
			{
				$props["Records"]=$result.records
				$props["ComponentDescription"]=$result.Component_description
				$props["Manufacturer"]=$result.manufacturer
				$props["DefectSummary"]=$result.defect_summary
				$props["Summary"]=$result.consequence_summary
				$props["CorrectiveAction"]=$result.corrective_summary
				$props["Notes"]=$result.notes
				$props["Subject"]=$result.recall_subject													
			}
			if($result.description)
			{
				$props["Description"]=$result.description
				$props["Summary"]=$result.summary								
			}
          $outputData = New-Object -TypeName PSObject -Property $props
		  $outPutData			
		}
						
		}
			end
			{
				$webclient.Dispose()
			}
	}
####
Function Get-MovieDetails
{
		<#	
		.SYNOPSIS
			Get-MovieDetails gets information about movies from the OMDB API.
		
		.DESCRIPTION
			Get-MovieDetails gets information about movies from the OMDB API using a title provided or title and year.
		
		.PARAMETER Title
			A title of a movie to get information on from the OpenMovieDatabase.
			
		.PARAMETER 	Year
			A year to allow for a more exact search of the OMDB.
			
		.PARAMETER RT
			Switch that also pulls RottenTomatoes information down with the OMDB information.
		
		.EXAMPLE
			Get-MovieDetails -Title "Dune" -RT
			Gets details for the 1984 release of Dune with RottenTomatoes details as well.
			
		.EXAMPLE
			Get-MovieDetails -Title "Dune" -Year 2000
			Get details about the 2000 release of the Dune Mini-Series.
		
	#>
	[CmdletBinding()]	
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Movie')]$Title,
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Release')]$Year,		
		[switch]
		$RT
    )
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		If($RT)
		{
			$url = "http://www.omdbapi.com/?t=$title&y=$year&r=xml&tomatoes=true"			
		}
		else
		{
			$url = "http://www.omdbapi.com/?t=$title&y=$year&r=xml"
		}
		[xml]$xmlData = $webclient.downloadstring($url)
		$movie = $xmlData.root.movie
	 	$movie
	}
	end
	{
		$webclient.Dispose()
	}
}
####
#The below function may not work any longer. I can no longer access their API thru this method. :(
Function Get-FarmersMarkets
{
		<#	
		.SYNOPSIS
			Get-FarmersMarkets gets information about Farmers Markets in the United States from USDA's API.
		
		.DESCRIPTION
			Get-FarmersMarkets gets information about Farmers Markets in the United States from USDA's API using either a zip code or lat/long coordinates.
		
		.PARAMETER zip
			Provide a valid U.S. Postal zip code for the call to the USDA API.
			
		.PARAMETER lat
			Provide a valid latitude coordinate for USDA's API. Must be used with a longitude as well.
		
		.PARAMETER lng
			Provide a valid longitude coordinate for USDA's API. Must be used with a latitude as well.
		
		.EXAMPLE
			Get-FarmersMarkets -zip 87801
			Gets farmers markets near Socorr, NM
			
		.EXAMPLE
			Get-Content computers.txt | Get-Blank
		
		.NOTES
			This function may not work any longer. I can no longer access their API thru this method. :(
	#>
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
		$webclient.Dispose()
	}	
}
#####
function Get-GeoIP 
{
		<#	
		.SYNOPSIS
			Gets geographical information based on IP Address from freegeoip's API. If one is not supplied, uses the current machine's Public IP Address.
		
		.DESCRIPTION
			Gets geographical information based on IP Address. If one is not supplied, uses the current machine's Public IP Address. Includes Latitude and Longitude in results.
		
		.PARAMETER ip
			Public IP Address to be used in the API call.
		
		.EXAMPLE
			Get-GeoIP
			Gets geographical information based on the current machine's public IP Address.
			
		.EXAMPLE
			Get-GeoIP -IP 8.8.8.8
			Gets geographical information for Google's DNS Server IP Address.
		
	#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('IPAddress')]
        [ValidateScript({$_ -match [System.Net.IPAddress]$_ })] 
        [string[]]$ip
    )
    begin {
        $webclient = New-Object System.Net.webclient
        $providerRoot = "http://freegeoip.net/xml/"
    }
    process {
            [xml]$geoData = $webclient.downloadstring($providerRoot+$ip)
            Write-Output $geoData.response
    }
    end
	{
		$webclient.Dispose()
	}
}
#####
Function Get-Weather {
	<#	
		.SYNOPSIS
			Get-Weather gets weather information from OpenWeather's API.
		
		.DESCRIPTION
			Get-Weather gets weather information from OpenWeather's API using either a City or lat/long coordinates.
		
		.PARAMETER cityName
			Provide a cityName that can be found through openweather's API.
			
		.PARAMETER lat
			Provide a valid latitude coordinate for openweather's API. Must be used with a longitude as well.
		
		.PARAMETER long
			Provide a valid longitude coordinate for openweather's API. Must be used with a latitude as well.
			
		.PARAMETER Imperial
			Switch that changes the returned units to imperial instead of metric.
		
		.EXAMPLE
			Get-Weather -City "Anchorage" -Imperial
			Retruns the weather for Anchorage, AK in imperial units using the Alias of City for the cityName parameter.
			
		.EXAMPLE
			Get-GeoIP | Get-Weather
			Retruns the weather for the area of the current machine's Public IP Address in metric units.
		
	#>
[CmdLetBinding()]
Param (
    [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true,ParameterSetName='City')][Alias('city')]
    [string]$cityName,

    [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true,ParameterSetName='Coordinates')][Alias('latitude')]
    [int]$lat,

    [Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true,ParameterSetName='Coordinates')][Alias('longitude')]
    [int]$long,

    [switch]$Imperial        
)

BEGIN{
    $webclient = New-Object System.Net.webclient
}

PROCESS {
    if($PSCmdlet.ParameterSetName -eq 'Coordinates'){
        $url = "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&mode=xml"
    } elseif($PSCmdlet.ParameterSetName -eq 'City') {
        $url = "http://api.openweathermap.org/data/2.5/weather?q=$cityName&mode=xml" 
    }

    if($Imperial){
        $url = $url + '&units=imperial'
    } else {
        $url = $url + '&units=metric'
    }

    try {
        [xml]$xmlData = $webclient.downloadstring($url)
        $w = $xmlData.current
        $props = [ordered]@{
            city            = $w.city.name
            country         = $w.city.country
            latitude        = $w.city.coord.lat
            longitude       = $w.city.coord.lon
            sunrise         = [datetime]$(Get-Date $w.city.sun.rise).ToLocalTime()
            sunset          = [datetime]$(Get-Date $w.city.sun.set).ToLocalTime()
            temperature     = $w.temperature.value
            maxTemp         = $w.temperature.max
            minTemp         = $w.temperature.min
            humidity        = $w.humidity.value
            pressure        = $w.pressure.value
            windSpeed       = $w.wind.speed.value
            windDirection   = $w.wind.direction.value
            cloudState      = $w.clouds.name
            observationtime = [datetime](Get-Date $w.lastupdate.value).ToLocalTime()
        }
        Write-Output (New-Object -TypeName PSObject -Property $props)
    }
    catch {
        Write-Error "Location Not Found"
    }  
}

END{
    $webclient.Dispose()
}
}
####
###DO NOT SHARE####
Function Get-ITBooks
{
		<#	
		.SYNOPSIS
			Get-ITBooks gets information from it-ebooks' API.
		
		.DESCRIPTION
			Gets ITBooks information and download links, if available, for IT Ebooks.
		
		.PARAMETER query
			The query parameter sets the value that should be used when calling the API.
		
		.EXAMPLE
			PS C:\> Get-Blank <ComputerName>
			
		.EXAMPLE
			Get-Content computers.txt | Get-Blank
		
		.NOTES
			Additional information about the function.
	#>
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Search')]$query				
	)	
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		$url = "http://it-ebooks-api.info/v1/search/$query"
		$jsonData = $webclient.downloadstring($url)
		$results = ConvertFrom-Json $jsonData
		ForEach($book in $results.books.id)
		{
			$url2 = "http://it-ebooks-api.info/v1/book/$book"
			$jsonData = $webclient.downloadstring($url2)
			$result = ConvertFrom-Json $jsonData			
			$props = [ordered]@{Title=$result.title
								Description=$result.Description
								Author=$result.Author
								ISBN=$result.isbn
								Download=$result.download
			}
          $outputData = New-Object -TypeName PSObject -Property $props
		  $outPutData											
		}
	}
		end
		{
    		$webclient.Dispose()			
		}		
}
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
<###Example
$area = Get-GeoIP
Get-Answer -Search "$($area.city), $($area.RegionName)"
###>
# http://en.wikipedia.org/w/api.php?action=parse&page=Firefly&format=json&prop=text&section=0
Function Get-BookInfo
#Is currently broken. Attempting to fix the flaw.
{
		<#	
		.SYNOPSIS
			A brief description of the Get-Blank function.
		
		.DESCRIPTION
			A detailed description of the Get-Blank function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
		
		.EXAMPLE
			PS C:\> Get-Blank <ComputerName>
			
		.EXAMPLE
			Get-Content computers.txt | Get-Blank
		
		.NOTES
			Additional information about the function.
	#>
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Title')]$query,
		[Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Type','ISBN','OCLC','OLID','LCCN')]$id						
	)	
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		$query = ":$($query)"
		$prop = "$id$query"
		$url = "http://openlibrary.org/api/books?bibkeys=$prop&jscmd=data&format=json"
		$jsonData = $webclient.downloadstring($url)
		$results = ConvertFrom-JSON $jsonData
		[array]$bookinfo += $results.$prop
		$bookinfo # | Select Title, Subtitle, Number_of_pages, url, publish_date
	}
	end
	{
		$webclient.Dispose()		
	}
}
###
Function Get-News
{
		<#	
		.SYNOPSIS
			Get-News gets news article titles and urls from FeedZilla's api.
		
		.DESCRIPTION
			Get-News gets news article titles and urls from FeedZilla's api. Properties returned are Title, Url, Author, Publish_date, Source, Source_url, Summary.
			Get-News is designed to be used in two different ways. Run Get-News and gets everything from each of the categories.(May take a while). Run Get-News with a query 
			to search for a specific topic or word. 
		
		.PARAMETER query
			The query parameter sets the value that should be used when calling the API when searching.
			
		.EXAMPLE
			$news = Get-News
			Gets all of the articles from the API and stores it in the variable $news
			
		.EXAMPLE
			Get-News -query "ISIS"
			Gets all the of the articles that come up using ISIS as the search in the API call.

	#>
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Category')]$query		
	)	
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		If(!$query)
		{
			$url = "http://api.feedzilla.com/v1/categories.json"
			$jsonData = $webclient.downloadstring($url)
			$results = ConvertFrom-JSON $jsonData
			$categoryid = $results.category_id
			$category = $results | Select -ExpandProperty Category_id
			ForEach($id in $category)
			{
				$url2 = "http://api.feedzilla.com/v1/categories/$id/articles.json"
				$jsonData = $webclient.downloadstring($url2)			
				$result = ConvertFrom-Json $jsonData
				[array]$article += $result.articles					
			}			
		}
		elseif($query)
		{
			$url = "http://api.feedzilla.com/v1/articles/search.json?q=$query"
			$jsonData = $webclient.downloadstring($url)
			$results = ConvertFrom-JSON $jsonData
			$article = $results.articles			
		}
		$article
	}
	end
	{
		$webclient.Dispose()		
	}
}
Function Get-Definition
{
		<#	
		.SYNOPSIS
			Gets a definition for word from onelook.com's api.
		
		.DESCRIPTION
			Get-Definition retrieves a definition for the word from onelook.com's api.
		
		.PARAMETER word
			The word parameter sets the value for the word to be defined when calling the API.
		
		.EXAMPLE
			Get-Definition -word "Sword"
			Retrives the defintion for the word sword from Onelook and lists a phrase with that word, along with links for more resources on that word.
		.EXAMPLE
			Get-Content wordlist.txt | ForEach {Get-Definition $_}
			Retrives the definition for each word in worldlist.txt.

	#>
    param
    (
        [Parameter(Position=0, Mandatory=$false)][Alias('Query')]$word		
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
Function Get-Quakes
{
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		$url = "http://www.kuakes.com/json/"
			$jsonData = $webclient.downloadstring($url)
			$results = ConvertFrom-JSON $jsonData
			$results | Select Id, Title, Mag, Link, Lat, Lng, Time
	}
	end
	{
    	$webclient.Dispose()			
	}						
}													