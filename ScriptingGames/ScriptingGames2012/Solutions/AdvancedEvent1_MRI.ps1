#MonitorNotepadFor10Seconds.ps1 
#Revise below co-worker's script

$notepad = Get-Process notepad
for ($i = 1 ; $i ‐le 10 ; $i++)
{
 	start‐sleep 1
 	$notepad
}
#Revised script below
$notepad = Get-Process notepad -ErrorAction SilentlyContinue
If($notepad)
{
	for($i = 1; $i -le 10; $i++)
	{
		Start-Sleep 1
		$notepad
	}
}
else{"Notepad is not running"}