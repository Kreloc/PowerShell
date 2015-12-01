Function Get-QuakeData
{
		<#	
		.SYNOPSIS
			Gets a list of recent Earthquakes from www.kuakes.com
		
		.DESCRIPTION
			Gets a list of recent Earthquakes from www.kuakes.com. Uses the API availabe from them.
		
		.EXAMPLE
			Get-QuakeData
			
            Retrives a list of recent Earthquakes.

	#>
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