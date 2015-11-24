function Get-Excuse 
{
    If(!$excuses)
    {
        $client = New-Object System.Net.WebClient
        $global:excuses = (($client.DownloadString("http://pages.cs.wisc.edu/~ballard/bofh/excuses")).split([Environment]::NewLine))        
    }
    $excuses[(get-random $excuses.count)]
}