Function Get-GeoIP 
{
    	<#	
		.SYNOPSIS
			Get-GeoIP retrieves the public ip address of the local machine or another machine on the network by IP address.
		
		.DESCRIPTION
			Get-GeoIP retrieves the public ip address of the local machine or another machine on the network by IP address.
		
		.PARAMETER ip
			This parameter can be used to specify an IP address to find information on using the FreeGeoIP service. Default is the machine using the function.
		
		.EXAMPLE
			PS C:\> Get-GeoIP
			
		.EXAMPLE
			Get-GeoIP -ip 192.168.1.55
		
		.NOTES
			Additional information about the function.
	#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('IPAddress')]
        [ValidateScript({$_ -match [System.Net.IPAddress]$_ })] 
        [string[]]$ip
    )
    begin 
    {
        $webclient = New-Object System.Net.webclient
        $providerRoot = "http://freegeoip.net/xml/"
    }
    process 
    {
            [xml]$geoData = $webclient.downloadstring($providerRoot+$ip)
            Write-Output $geoData.response
    }
    end{}
}
