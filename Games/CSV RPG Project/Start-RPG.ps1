If(Test-Path .\RPG.CSV)
{
	$gamedb = Import-CSV .\RPG.CSV
}
else
{
	New-Item -path .\RPG.CSV -Type File | Out-Null
	$gamedb = Import-CSV .\RPG.CSV
}
##Dice Rolling
function Roll-Dice
{
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True)]
		[Int]$Sides,
		[Int]$NumberOfDie
	)
	PROCESS
	{
		$DiceRolls = 1..$NumberOfDie | ForEach {Get-Random -Minimum 1 -Maximum $($Sides + 1)}
		$RollstoSum = $DiceRolls -join '+'
		$Sum = Invoke-Expression $RollstoSum 
		$Total = New-Object -TypeName PSObject
		$Total | Add-Member -MemberType NoteProperty -Name Sum -Value $Sum
		$Total | Add-Member -MemberType NoteProperty -Name Rolls -Value $DiceRolls
		$Total | Add-Member -MemberType NoteProperty -Name JoinedRolls -Value $RollstoSum
		$Total
	}
}
###Create Player Characters
Function Create-Character($name)
{
	$WS = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$BS = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$S = (Roll-Dice -Sides 6 -NumberofDie 2).Sum + 10
	$T = (Roll-Dice -Sides 6 -NumberofDie 2).Sum + 10
	$HP = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$Ag = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$Wp = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$ExpTotal = 0
	$CurEXP = 0
	$Level = 1
	$Career = "Free"
	$props = [ordered]@{Name=$Name
				WS=$WS
				BS=$BS
				S=$S
				T=$T
				Ag=$Ag
				Wp=$Wp
				curHP=$HP
				HP=$HP				
				Exp=$ExpTotal
				Level=$Level
				JobName=$Career				
				Monster=$false
				}
	$pc = New-Object PSObject -Property $props
	$pc | Export-CSV .\RPG.csv -Append -NoTypeInformation
	$pc
}
###Create Monsters
Function Create-Enemy($race)
{
	$WS = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 10
	$BS = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 10
	$S = (Roll-Dice -Sides 6 -NumberofDie 2).Sum + 10
	$T = (Roll-Dice -Sides 6 -NumberofDie 2).Sum + 10
	$HP = (Roll-Dice -Sides 6 -NumberofDie 2).Sum + 10
	$Ag = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 10
	$Wp = (Roll-Dice -Sides 10 -NumberofDie 2).Sum + 20
	$ExpTotal = 0
	$CurEXP = 0
	$Level = 1
	$Career = "Free"
	$props = [ordered]@{Name=$race
				WS=$WS
				BS=$BS
				S=$S
				T=$T
				Ag=$Ag
				Wp=$Wp
				curHP=$HP
				HP=$HP				
				Exp=$ExpTotal
				Level=$Level
				JobName=$Career				
				Monster=$true
				}
	$enemy = New-Object PSObject -Property $props
	$enemy | Export-CSV .\RPG.csv -Append -NoTypeInformation
	$enemy	
}