
	

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
	$props = @{Name=$Name
				WS=$WS
				BS=$BS
				S=$S
				T=$T
				HP=$HP
				Ag=$Ag
				Wp=$Wp
				curHP=$HP
				Exp=$ExpTotal
				Monster=$false
				}
	$pc = New-Object PSObject -Property $props
	$pc | Export-CSV .\RPG.csv -Append
}
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
	$props = @{Name=$race
		 		WS=$WS
				BS=$BS
				S=$S
				T=$T
				W=$W
				Ag=$Ag
				Wp=$Wp
				curW=$W
				Exp=$ExpTotal
				Monster=$True
				}
	$enemy = New-Object PSObject -Property $props
	$enemy | Export-CSV .\RPG.csv -Append	
}
Function Start-Combat
{
	begin{}
	process
	{
		$battlecount = 0
		$count = 0
		$pcfirstmove = 0
		$enemryfirstmove = 0
		Do
		{
			If($pc.ag -gt ($enemy.ag - 1))
			{
				"Player attacks first!"
				$pcfirstmove++
				$Playerchoice = "Attack"
				If($Playerchoice -like "*Attack*")
				{
					$roll = (Roll-Dice -Sides 100 -NumberofDie 1).Sum
					If($Roll -le $pc.WS)
					{
						$dam = ((Roll-Dice -Sides 6 -NumberofDie 1).Sum) + $pc.S - $enemy.T
						Write-Host "Attack on enemy for $dam damage."
						If($dam -gt 0)
						{
							$enemy.curW = $enemy.w - $dam
							If($enemy.curW -le 0)
							{
								"Enemy was defeated!"
								$battlecount = 1
								$count++
							}		
						}
						else
						{
							"Attack had no effect"
						}
					}
					elseif($Roll -gt $pc.WS)
					{
						"Attack missed enemy. Enemies turn."
					}	
				}
			}
			If($pc.ag -lt $enemy.ag)
			{
				"Enemy attacks first!"
				$enemyfirstmove++			
				$roll =  (Roll-Dice -Sides 100 -NumberofDie 1).Sum
				If($Roll -le $enemy.WS)
				{
					$dam = ((Roll-Dice -Sides 6 -NumberofDie 1).Sum) + $enemy.S - $pc.T
					If($dam -gt 0)
						{
							$pc.curW = $pc.W - $dam
							Write-Host "You took $dam!"
							If($pc.curW -le 0)
							{
								"Player has died!"
								$battlecount = 1
								$count++
							}
						}
						else
						{
							"Enemy attack had no effect."
						}
				}
				elseif($Roll -gt $enemy.WS)
				{
					"Attack missed player. Player's turn."
				}					
			}
			$count++			
		}
		until ($count -eq 1)
		$battlecount = 1
		Do
		{
			$count++
			If($pcfirstmove -lt $enemyfirstmove)
			{
				"Player's turn!"
				$pcfirstmove++
				$Playerchoice = "Attack"
				If($Playerchoice -like "*Attack*")
				{
					$roll = (Roll-Dice -Sides 100 -NumberofDie 1).Sum
					If($Roll -le $pc.WS)
					{
							$dam = ((Roll-Dice -Sides 6 -NumberofDie 1).Sum) + $pc.S - $enemy.T
							"Attack on enemy for $dam damage."
							If($dam -gt 0)
						{
							$enemy.curW = $enemy.curW - $dam
						If($enemy.curW -le 0)
						{
							"Enemy was defeated!"
							$battlecount = 1
						}								
						}
						else
						{
							"Attack had no effect on enemy."
						}
					}
					elseif($Roll -gt $pc.WS)
					{
						"Attack missed enemy. Enemies turn."
					}	
				}
				
							$battlecount++
			}
			If($enemyfirstmove -lt $pcfirstmove)
			{
				"Enemies turn!"
				$enemyfirstmove++			
				$roll =  (Roll-Dice -Sides 100 -NumberofDie 1).Sum
				If($Roll -le $enemy.WS)
				{
					$dam = ((Roll-Dice -Sides 6 -NumberofDie 1).Sum) + $enemy.S - $pc.T
					If($dam -gt 0)
						{
						$pc.curW = $pc.curW - $dam
						Write-Host "You took $dam!"
						If($pc.curW -le 0)
						{
							"Player has died"
							$battlecount = 1
						}
						}
						else
						{
							"Enemy attack had no effect."
						}
				}
				elseif($Roll -gt $enemy.WS)
					{
						"Attack missed player. Player's turn."
					}	
								$battlecount++	
								$count++			
			}
			else
			{
				$roll = (Roll-Dice -Sides 100 -NumberofDie 1).Sum
				"Player's Turn!"
					If($Roll -le $pc.WS)
					{
							$dam = ((Roll-Dice -Sides 6 -NumberofDie 1).Sum) + $pc.S - $enemy.T
							"Attack on enemy for $dam damage."
							If($dam -gt 0)
						{
							$enemy.curW = $enemy.curW - $dam
						If($enemy.curW -le 0)
						{
							"Enemy was defeated!"
							$battlecount = 1
						}							
						}
						else
						{
							"Attack had no effect on enemy."
						}
					}
					elseif($Roll -gt $pc.WS)
					{
						"Attack missed enemy. Enemies turn."
					}
					"Enemies turn!"
					$roll =  (Roll-Dice -Sides 100 -NumberofDie 1).Sum
				If($Roll -le $enemy.WS)
				{
					$dam = ((Roll-Dice -Sides 6 -NumberofDie 1).Sum) + $enemy.S - $pc.T
					If($dam -gt 0)
						{
						$pc.curW = $pc.curW - $dam
						Write-Host "You took $dam!"
						If($pc.curW -le 0)
						{
							"Player has died"
							$battlecount = 1
						}
						}
						else
						{
							"Enemy attack no effect."
						}
				}
				elseif($Roll -gt $enemy.WS)
					{
						"Attack missed player. Player's turn."
					}							
								$battlecount++
								$count++				
			}
			"Player has $($pc.CurW) out $($pc.W) remaining."
			If($enemy.curW -ge 0 -and $pc.curW -ge 0)
			{
			$choice = Read-Host "Continue to fight?(Enter Fight or Run)"
			If($choice -like "*Yes*" -or $choice -like "*Fight*")
			{
				$battlecount = 0
			}
			If($Choice -like "*No*" -or $choice -like "*Run*")
			{
				"You ran away!"
				$battlecount = 1
			}
			}
			else
			{
				$battlecount = 1
			}
		}		
	Until ($battlecount -eq 1)
		$count = 2	
			$pc
	$enemy
	}

}

