Function Level-Up($pc)
{
	#Use a switch statement for this one
	switch ($pc.Level)
	{
	"[2-8]" {$pc.Hp = [Math]::Round([decimal]$pc.HP + 2)
		$pc.WS = [Math]::Round([decimal]$pc.WS + 2)
		$pc.BS = [Math]::Round([decimal]$pc.BS + 2)
		$pc.S = [Math]::Round([decimal]$pc.S + 2)
		$pc.T = [Math]::Round([decimal]$pc.T + ($pc.T * .025))
		$pc.Ag = [Math]::Round([decimal]$pc.Ag + ($pc.Ag * .025))
		$pc.WP = [Math]::Round([decimal]$pc.WP + ($pc.WP * .025))
	}
	}
	$pc
}