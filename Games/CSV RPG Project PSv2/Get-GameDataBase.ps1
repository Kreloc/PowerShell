Function Get-GameDataBase
{
	If(!(Test-Path("$pwd\gamedb.txt")))
	{
		New-Item -Path "$pwd\gamedb.txt" -ItemType "File" | Out-Null
		Add-Content -Path "$pwd\gamedb.txt" -Value "IdKey,Name,Race,Class,WS,BS,S,T,W,Ag,Wp,Items,CurExp,ExpTotal"
	}
	$global:gamedb = Import-CSV "$pwd\gamedb.txt"
}