Function Change-Jobs([object]$pc)
{
	$jobchoice = Read-Host "Enter Job Choice"
	$jobs = Import-CSV .\jobs.csv 
    $job = $jobs | Where {$_.JobName -eq "$jobchoice"}
	$pc.HP = [Math]::Round([decimal]$pc.HP * $job.HP)
	$pc.BS = [Math]::Round([decimal]$pc.BS * $job.BS)
	$pc.WS = [Math]::Round([decimal]$pc.WS * $job.WS)
	$pc.S = [Math]::Round([decimal]$pc.S * $job.S)
	$pc.T = [Math]::Round([decimal]$pc.T * $job.T)
	$pc.Ag = [Math]::Round([decimal]$pc.Ag * $job.Ag)
	$pc.Wp = [Math]::Round([decimal]$pc.Wp * $job.Wp)
	$pc
	[array]$gameDb = Import-CSV .\RPG.csv | Where {$_.Name -notmatch $pc.name}
	$gameDb += $pc
	$gameDB | Export-CSV .\RPG.csv -NoTypeInformation 
}