Function Get-Weather 
{
  	<#	
		.SYNOPSIS
			Get-Weather retrieves weather information for the specified locale.
		
		.DESCRIPTION
			Get-Weather retrieves weather information for the specified locale using the openweathemap api.
		
		.PARAMETER CityName
			The name of a city to get retieve weather information.
            
         .PARAMETER lat
            The latitude of a location. Used to call the api
          
          .PARAMETER long
		      The longitude of a location. Used to call the api.
              
        .PARAMETER Imperial
             A switch to change the returned units into Imperial units of measurement. (Fairenheight, etc.)
          
		.EXAMPLE
			Get-Weather -CityName "Anchorage"
            
        .EXAMPLE
            Get-GeoIp | Get-Weather            
		
		.NOTES
			This function was originally posted on /r/PowerShell and has some small edits.
	#>  
[CmdLetBinding()]
Param 
(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true,ParameterSetName='City')][Alias('city')]
    [string]$cityName,

    [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true,ParameterSetName='Coordinates')][Alias('latitude')]
    [int]$lat,

    [Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true,ParameterSetName='Coordinates')][Alias('longitude')]
    [int]$long,

    [switch]$Imperial        
)

    Begin
    {
        $webclient = New-Object System.Net.webclient
    }

    Process
    {
        if($PSCmdlet.ParameterSetName -eq 'Coordinates')
        {
            $url = "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&mode=xml"    
        } 
        elseif($PSCmdlet.ParameterSetName -eq 'City') 
        {
            $url = "http://api.openweathermap.org/data/2.5/weather?q=$cityName&mode=xml" 
        }
        if($Imperial)
        {
            $url = $url + '&units=imperial'
        }
           else
        {
            $url = $url + '&units=metric'
        }
        try
        {
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
        catch 
        {
            Write-Error "Location Not Found"
        }  
    }
    End
    {
        $webclient.Dispose()
    }
}