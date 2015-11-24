Function Get-CareerClass
{
	If ($($PC.Race) -ne "Elf")
{
	If ($($PC.WS) -ge 30)
	{
		$CareerClassOption1 = "Warrior"
	}
	If ($($PC.BS) -ge 30)
	{
		$CareerClassOption2 = "Ranger"
	}
	If ($($PC.I) -ge 30)
	{
		$CareerClassOption3 = "Rogue"
	}
	If ($($PC.Int) -ge 30 -and $WP -ge 30)
	{
	$CareerClassOption4 = "Academic"
	}
}
If ($($PC.Race) -eq "Elf")
{
	If ($($PC.WS) -ge 30)
	{
		$CareerClassOption1 = "Warrior"
	}
	If ($($PC.BS) -ge 30)
	{
		$CareerClassOption2 = "Ranger"
	}
	If ($($PC.I) -ge 65)
	{
		$CareerClassOption3 = "Rogue"
	}
	If ($($PC.Int) -ge 30 -and $WP -ge 30)
	{
	$CareerClassOption4 = "Academic"
	}
}
$CC = $CareerClassOption1, $CareerClassOption2, $CareerClassOption3, $CareerClassOption4
Write-Host "M $($PC.M) WS $($PC.WS) BS $($PC.BS) S $($PC.S) T $($PC.T) W $($PC.W) I $($PC.I) A $($PC.A) Dex $($PC.Dex) Ld $($PC.Ld) Int $($PC.Int) Cl $($PC.Cl) WP $($PC.WP) Fel $($PC.Fel)"
$CareerClass = Read-Host "Which career class?($CC)"
$PC | Add-Member -MemberType NoteProperty -Name CareerClass -Value $CareerClass
}