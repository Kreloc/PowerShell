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
		$Total
	}
}