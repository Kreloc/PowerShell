Function Set-GameDatabase
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False)]
		[string]$Path = "$($ENV:USERPROFILE)\Documents"
	)
	Begin
	{
		$MonsterDBExists = Test-Path $Path\mon.txt
		$PCDBExists = Test-Path $Path\pc.txt
		$ItemDBExists = Test-Path $Path\it.txt
	}
	Process
	{
		If($MonsterDBExists)
		{
			$MonsterDB = Import-CSV $Path\mon.txt
		}
		elseif(!($MonsterDBExists))
		{
			#Create Monster Database
			New-Monsters -Path\mon.txt
			$MonsterDB = Import-CSV $Path\mon.txt						
		}
		If($PCDBExists)
		{
			$PCDB = Import-CSV $Path\pc.txt
		}
		elseif(!($PCDBExists))
		{
			#Create PC Database
			New-Character -Path $Path
			$PCDB = Import-CSV $Path\pc.txt			
		}
		If($ItemDBExists)
		{
			$ItemDB = Import-CSV $Path\it.txt
		}
		elseif(!($ItemDBExists))
		{
			#Create Item/Magic Database
			New-Items -Path $Path
			$ItemDB = Import-CSV $Path\it.txt			
		}				
	}
	End
	{
		#These variables need to be adjusted away from global, but for now that's where they are...
		$global:MonsterDB = $MonsterDB
		$global:PCDB = $PCDB
		$global:$ItemDB = $ItemDB
	} 
}