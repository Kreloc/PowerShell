Function Get-MovieData
{
		<#	
		.SYNOPSIS
			Get-MovieData gets information about movies from the OMDB API.
		
		.DESCRIPTION
			Get-MovieData gets information about movies from the OMDB API using a title provided or title and year.
		
		.PARAMETER Title
			A title of a movie to get information on from the OpenMovieDatabase.
			
		.PARAMETER 	Year
			A year to allow for a more exact search of the OMDB.
			
		.PARAMETER RT
			Switch that also pulls RottenTomatoes information down with the OMDB information.
		
		.EXAMPLE
			Get-MovieData -Title "Dune" -RT
			Gets details for the 1984 release of Dune with RottenTomatoes details as well.
			
		.EXAMPLE
			Get-MovieData -Title "Dune" -Year 2000
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