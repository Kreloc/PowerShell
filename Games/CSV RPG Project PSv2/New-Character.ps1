Function New-Character
	param
	(
		[Parameter(Mandatory=$False)]
		[string]$Path = "$($ENV:USERPROFILE)\Documents",
		[Paramether(Mandatory=$True)]
		[string]$Name
	)
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
	$IdKey = 1	
	#Headers for csv file are as follows:
	#Name,Race,Level,Class,WS,BS,S,T,W,Ag,Wp,CurExp,ExpTotal,
	New-Item -Path "$Path\pc.txt" -ItemType "File" | Out-Null
	Add-Content -Path "$Path\pc.txt" -Value "IdKey,Name,Race,Level,WS,BS,S,T,W,Ag,Wp,Items,CurExp,ExpTotal"		
	Add-Content -Path "$Path\pc.txt" -Value "$IdKey,$($Name),Human,$Level,$($class),$($WS),$($BS),$($S),$($T),$($W),$($Ag),$($Wp),Sword,$($CurExp),$($ExpTotal)"
}