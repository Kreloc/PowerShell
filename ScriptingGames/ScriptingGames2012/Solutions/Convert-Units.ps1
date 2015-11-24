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