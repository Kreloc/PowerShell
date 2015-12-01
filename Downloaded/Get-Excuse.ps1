function Get-Excuse 
{
    $client = New-Object System.Net.WebClient
    $excuses = (($client.DownloadString("http://pages.cs.wisc.edu/~ballard/bofh/excuses")).split([Environment]::NewLine))
    $excuses[(get-random $excuses.count)]
}