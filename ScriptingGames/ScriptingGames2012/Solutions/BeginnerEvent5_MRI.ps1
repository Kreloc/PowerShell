#Get-EventLog -LogName Application -EntryType Error

$ErrorLog = Get-EventLog -LogName Application -EntryType Error 
[array]$endResults += $ErrorLog | Sort -Unique Source | Select Source | 
ForEach-Object{
	$Errorcount = ($ErrorLog | Where {$_.Source -like "$($_.Source)"}).count
	$props = @{"Name"="$($_.Source)"
				"Count"=$Errorcount
	}
	$results = New-Object -TypeName PSObject -Property $props
	$results
}
$endresults
$count = ($ErrorLog | Where {$_.Source -like "$test"}).count