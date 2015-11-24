###Begin of source code compatible with v2 of PowerShell.###
###Loading or creating the csv file that is the database for the game.
If(Test-Path .\RPG.txt)
{
	$gamedb = Import-CSV .\RPG.txt
}
else
{
	New-Item -path .\RPG.CSV -Type File | Out-Null
	$gamedb = Import-CSV .\RPG.CSV
	$pc = $gamedb | Where {$_.Name -like "*"}
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
###Character Creation
Function Create-Character ($name)
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
	$pc = New-Object -TypeName PSCustomobject 
	$pc | Add-Member -MemberType NoteProperty -Name Name -Value $name -PassThru | Add-Member -MemberType NoteProperty -Name WS -Value $WS -PassThru | Add-Member -MemberType NoteProperty -Name BS -Value $BS -PassThru | 
	Add-Member -MemberType NoteProperty -Name S -Value $S -PassThru | Add-Member -MemberType NoteProperty -Name T -Value $T -PassThru | Add-Member -MemberType NoteProperty -Name HP -Value $HP -PassThru |
	Add-Member -MemberType NoteProperty -Name Ag -Value $Ag -PassThru | Add-Member -MemberType NoteProperty -Name Wp -Value $Wp -PassThru | Add-Member -MemberType NoteProperty -Name ExpTotal -Value $ExpTotal -PassThru |
	Add-Member -MemberType NoteProperty -Name CurExp -Value $CurExp -PassThru | Add-Member -MemberType NoteProperty -Name Level -Value $Level -PassThru | Add-Member -MemberType NoteProperty -Name JobName -Value $Career
	$pc | ConvertTo-CSV | Out-File .\RPG.CSV -NoClobber -Append
}
###Enemy Creation
Function Create-Enemy ($race)
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
	$Monster = $true			
	$mon = New-Object -TypeName PSCustomobject 
	$mon | Add-Member -MemberType NoteProperty -Name Race -Value $race -PassThru | Add-Member -MemberType NoteProperty -Name WS -Value $WS -PassThru | Add-Member -MemberType NoteProperty -Name BS -Value $BS -PassThru | 
	Add-Member -MemberType NoteProperty -Name S -Value $S -PassThru | Add-Member -MemberType NoteProperty -Name T -Value $T -PassThru | Add-Member -MemberType NoteProperty -Name HP -Value $HP -PassThru |
	Add-Member -MemberType NoteProperty -Name Ag -Value $Ag -PassThru | Add-Member -MemberType NoteProperty -Name Wp -Value $Wp -PassThru | Add-Member -MemberType NoteProperty -Name ExpTotal -Value $ExpTotal -PassThru |
	Add-Member -MemberType NoteProperty -Name CurExp -Value $CurExp -PassThru | Add-Member -MemberType NoteProperty -Name Level -Value $Level -PassThru | Add-Member -MemberType NoteProperty -Name Monster -Value $Monster
	$mon | ConvertTo-CSV | Out-File .\RPG.CSV -NoClobber -Append
}