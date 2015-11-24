Function New-Items
{
	param
	(
		[Parameter(Mandatory=$False)]
		[string]$Path = "$($ENV:USERPROFILE)\Documents"
	)
	Begin
	{}
	Process
	{
		New-Item -Path "$Path\it.txt" -ItemType "File" | Out-Null
		Add-Content -Path "$Path\it.txt" -Value "IdKey,Name,WS,BS,D,ED,Ag"
		Add-Content -Path "$Path\mon.txt" -Value "1,Sword,0,0,0,0,0"
		Add-Content -Path "$Path\mon.txt" -Value "2,Knife,-10,0,-1,0,+10"
		Add-Content -Path "$Path\mon.txt" -Value "3,Axe,0,0,0,0,0"								
	}	
}