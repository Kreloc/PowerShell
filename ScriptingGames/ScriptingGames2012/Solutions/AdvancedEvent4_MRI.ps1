Function Get-LargeFolders($path)
{
	Function Convert-Units($Size)
#Size should only ever be bytes to begin with.
{
	If($Size -le 1024)
	{
		$Size = "$($Size) Bytes"
	}
	ElseIf($Size -le 1048576)
	{
		$Size = "$([Math]::Round(($Size) / 1KB, 2)) KiloBytes"
	}
	ElseIf($Size -le 1073741824)
	{
		$Size = "$([Math]::Round(($Size) / 1MB, 2)) MegaBytes"
	}					
	ElseIf($Size -le 1099511627776)
	{
		$Size = "$([Math]::Round(($Size) / 1GB, 2)) GigaBytes"						
	}
	ElseIf($Size -gt 1099511627776)
	{
		$Size = "$([Math]::Round(($Size) / 1TB, 2)) TeraBytes"						
	}
	$Size	
}
	$results = $null
	$folders = Get-ChildItem $path | Where {$_.PSISContainer -eq $True}
	[array]$results += ForEach($folder in $folders)
	{
		$folder = $folder | Select FullName, @{name="Size";expression={((((Get-ChildItem -Path $folder.FullName -Recurse) | Measure-Object Length -Sum).Sum))}}
		$folder.Size = Convert-Units -Size $folder.Size
		$folder
	}
	$results
}