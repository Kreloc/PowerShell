Function New-Monsters
{
	param
	(
		[Parameter(Mandatory=$False)]
		[string]$Path = "$($ENV:USERPROFILE)\Documents"
	)
	Begin
	{
		$CreatureTable = @{1="Goblin";2="Beastmen";3="Orcs";4="Slimes";5="Ratmen";6="Troll"}
	}
	Process
	{
		New-Item -Path "$Path\mon.txt" -ItemType "File" | Out-Null
		Add-Content -Path "$Path\mon.txt" -Value "IdKey,Name,Level,WS,BS,S,T,W,Ag,Wp,Items,ExpDrop"
		Add-Content -Path "$Path\mon.txt" -Value "1,Goblin,1,21,18,2,2,5,25,23,Knife,2"
		Add-Content -Path "$Path\mon.txt" -Value "2,Beastmen,1,33,25,3,3,7,30,22,Sword,5"
		Add-Content -Path "$Path\mon.txt" -Value "3,Orcs,1,31,18,3,2,6,25,23,Axe,3"
		Add-Content -Path "$Path\mon.txt" -Value "4,Slimes,1,11,18,2,2,4,15,13,-,1"								
	}
}