Function Create-Monster ($name)
{
	$WS = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$BS = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$S = (Roll-Dice -Sides 6 -NumberofDie 2).Sum + 10
	$T = (Roll-Dice -Sides 6 -NumberofDie 2).Sum + 10
	$W = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$Ag = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$Wp = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$ExpTotal = 0
	$CurEXP = 0
	$Level = 1
	$Class = "Free"			
	Add-Content -Path "$pwd\gamedb.txt" -Value "$($name),Monster,$($class),$($WS),$($BS),$($S),$($T),$($W),$($Ag),$($Wp),,,Sword,,,"
	$global:gamedb = Import-CSV "$pwd\gamedb.txt"	
}