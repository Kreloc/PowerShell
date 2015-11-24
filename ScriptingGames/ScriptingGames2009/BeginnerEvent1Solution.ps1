$times = @{}
Get-Content "100 Meter Event.txt" | foreach {
    if (!($_.StartsWith("Name"))) {
        $i = $_.IndexOf(".")
        [double]$time = $_.Substring($i–1)
        $times += @{$_ = $time }      
    }
}
$winners = $times.GetEnumerator() | sort value  | select Name -First 3
$medals = @("Gold", "Silver", "Bronze")
for ($i=0;$i-le 3;$i++){
    "{0,-6} {1}" -f $($medals[$i]), $($Winners[$i].Name)
}

#Stolen from Richard Siddaway's blog. https://richardspowershellblog.wordpress.com/2009/06/16/games-beginner-1/

$results = Get-Content '.\100 Meter Event.txt'
ForEach($line in $results)
{
	$line = $line -replace '(^\s+|\s+$)','' -replace '\s+',' ' -replace ", ",","
	[array]$endresults += $line
}
	$endresults
