function

Set-Location $Path
$videos = Get-ChildItem .\* -Include *.avi, *.mp4, *.m4v, *.mkv | Sort Name
$intNo = 0
$show = ($videos[0].FullName -split "\\")[4]
$season = (($videos[0].FullName -split "\\")[5]) -replace ".*0"
$web = Invoke-WebRequest "http://thetvdb.com/api/GetSeries.php?seriesname=$show"
$showid = ([Xml]$web.content).Data.Series.seriesid
$apikey = "45E29D4700EE792E"
$webinfo = Invoke-WebRequest "http://thetvdb.com/api/$apikey/series/$showid/all/"
ForEach ($episode in $videos)
{
	$epNo = $intNo +1
	$xml = ([xml]$outfile)
	$showinfo = ([Xml]$webinfo.content).Data.Episode | Where {$_.SeasonNumber -eq $season -and $_.EpisodeNumber -eq $epNo} | Select EpiosdeName, OverView	
	$xml.details.overview = $($showinfo.overview)
	$xml.details.title = $($showinfo.EpisodeName)
	$xml.details.InnerXml | out-file .\$($episode.BaseName).xml
}

####Side Track Web Info
$web = Invoke-WebRequest "http://thetvdb.com/api/GetSeries.php?seriesname=$show"
$showid = ([Xml]$web.content).Data.Series.seriesid
$apikey = "45E29D4700EE792E"
$webinfo = Invoke-WebRequest "http://thetvdb.com/api/$apikey/series/$showid/all/"
$showinfo = ([Xml]$webinfo.content).Data.Episode | Where {$_.SeasonNumber -eq $season -and $_.EpisodeNumber -eq $epNo} | Select EpiosdeName, OverView
$title = $showinfo.EpisodeName
$overview = $showinfo.overview
#Props to gather title = EpisodeName, overview = overview 
$outfile = gc "C:\Users\Mark\SkyDrive\WDTV\template.xml"
$xml = ([xml]$outfile)
$xml.details.overview = $($showinfo.overview)
$xml.details.title = $($showinfo.EpisodeName)
$xml.details.InnerXml | out-file .\$($videos[0].BaseName).xml
##Realized after testing first one the device I was doing this on now supports doing this from it as of the last firmware update. God Damnit, someone has always beaten me to it. (WDTV Live Hub)

####
Function Get-MovieDetails
{
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
	}
}

####Examples of Usage
Get-MovieDetails -Title "Free Willy"

Get-MovieDetials -Movie "Free Willy" -RT

Get-MovieDetails "Free Willy" -RT | Select -ExpandProperty Outerxml | outfile FreeWilly.xml