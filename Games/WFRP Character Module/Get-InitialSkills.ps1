Function Get-InitialSkills 
{
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True)]
		$Race,
		$Age,
		$CareerClass
	)
	PROCESS 
	{
		$ErrorActionPreference = "silentlycontinue"
			If ($Race -eq "Human")
			{
				If ($Age -ge 16 -and $Age -le 20)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
				}
				Elseif ($Age -ge 21 -and $Age -le 30)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 1
				}		
				elseif ($Age -ge 31 -and $Age -le 40)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 2
				}
				elseif ($Age -ge 41 -and $Age -le 50)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 1					
				}
				elseif ($Age -ge 51 -and $Age -le 60)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
				}
				elseif ($Age -ge 61 -and $Age -le 70)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 - 1
				}	
				elseif ($Age -ge 71 -and $Age -le 80)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 - 2
				}
				$Skillarray = 1..$SkillRolls | %{ Get-Random -Minimum 1 -Maximum $(100 + 1) } #Creating array of D100 Rolls
				ForEach ($Roll in $Skillarray)
				{
					If ($CareerClass -eq "Warrior")
					{
					<#template for skill rolls
					If ($Roll -ge [int] -and le [int])
					{
						$Skill = '[string]'
					}
					#>
					##Warrior Class Skills
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Dance"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Disarm"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Dodge Blow'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Lightning Reflexes'
					}	
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 56 -and $Roll -le 65)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 66 -and $Roll -le 75)
					{
						$Skill = 'Ride'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 81 -and $Roll -le 85)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 86 -and $Roll -le 90)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Very Resilient'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}
					}
					###Ranger Class Skills
					If ($CareerClass -eq "Ranger")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Astronomy"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Dance"
					}
					If ($Roll -ge 21 -and $Roll -le 30)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Lightning Reflexes'
					}	
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Orientation'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Prepare Poisons (Herbal)'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Ride'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 81 -and $Roll -le 85)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 86 -and $Roll -le 90)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Very Resilient'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}											
					}
					##Rogue Class Skills
					If ($CareerClass -eq "Rogue")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Blather"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Bribery"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Dance'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Dodge Blow'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Flee!'
					}	
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Lightning Reflexes'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Ride'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Silent Move Rural'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Silent Move Urban'
					}
					If ($Roll -ge 81 -and $Roll -le 85)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 86 -and $Roll -le 90)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Street Fighting'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Resilient'
					}								
					}
					###Academic Skills
					If ($CareerClass -eq "Academic")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Astronomy"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Blather"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Cryptography'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Dance'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Etiquette'
					}	
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Flee!'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Heraldry'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Lightning Reflexes'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Ride'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Silent Move Urban'
					}
					If ($Roll -ge 81 -and $Roll -le 85)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 86 -and $Roll -le 90)
					{
						$Skill = 'Super Numerate'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Very Resilient'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}							
					} #End if Acadmeic
					[array]$SkillSet += $Skill
		} #End SkillRoll ForEach
	} #End for If Human
	If ($Race -eq "Elf")
	{
				If ($Age -ge 16 -and $Age -le 40)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
				}
				Elseif ($Age -ge 41 -and $Age -le 90)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 1
				}		
				elseif ($Age -ge 91 -and $Age -le 140)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 2
				}
				elseif ($Age -ge 141 -and $Age -le 190)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 3					
				}
				elseif ($Age -ge 191 -and $Age -le 200)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 2
				}
				elseif ($Age -ge 201 -and $Age -le 210)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 1
				}	
				elseif ($Age -ge 211 -and $Age -le 220)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
				}
				$Skillarray = 1..$SkillRolls | %{ Get-Random -Minimum 1 -Maximum $(100 + 1) } #Creating array of D100 Rolls
				[array]$SkillSet += "Excellent Vision"
				If ($Skillrolls -gt 1)
					{
						$Roll3Skills = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
						If ($Roll3Skills -eq 1)
						{
							$Skill = 'Dance'
						}
						If ($Roll3Skills -eq 2)
						{
							$Skill = 'Musicianship'
						}
						If ($Roll3Skills -eq 3)
						{
							$Skill = 'Sing'
						}						
					}
				$SkillSet += $Skill
				If ($SkillRolls -gt 2)
				{
				$SkillRolls = $null
				If ($Age -ge 16 -and $Age -le 40)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
				}
				Elseif ($Age -ge 41 -and $Age -le 90)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
					$SkillRolls = $SkillRolls1 + 1
				}		
				elseif ($Age -ge 91 -and $Age -le 140)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
					$SkillRolls = $SkillRolls1 + 2
				}
				elseif ($Age -ge 141 -and $Age -le 190)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
					$SkillRolls = $SkillRolls1 + 3					
				}
				elseif ($Age -ge 191 -and $Age -le 200)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
					$SkillRolls = $SkillRolls1 + 2
				}
				elseif ($Age -ge 201 -and $Age -le 210)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
					$SkillRolls = $SkillRolls1 + 1
				}	
				elseif ($Age -ge 211 -and $Age -le 220)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
				}
				$Skillarray = 1..$SkillRolls | %{ Get-Random -Minimum 1 -Maximum $(100 + 1) }
				ForEach ($Roll in $Skillarray)	
				{
					If ($CareerClass -eq "Warrior")
					{
					<#template for skill rolls
					If ($Roll -ge [int] -and le [int])
					{
						$Skill = '[string]'
					}
					#>
					##Warrior Class Skills
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Dance"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Disarm"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Dodge Blow'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Lightning Reflexes'
					}	
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 56 -and $Roll -le 65)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Ride'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Silent Move Rural'
					}					
					If ($Roll -ge 81 -and $Roll -le 90)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Resilient'
					}
					}
					###Ranger Class Skills
					If ($CareerClass -eq "Ranger")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Astronomy"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Dance"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 26 -and $Roll -le 35)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Lightning Reflexes'
					}	
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Orientation'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Prepare Poisons (Herbal)'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Ride'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Silent Move Rural'
					}
					If ($Roll -ge 81 -and $Roll -le 90)
					{
						$Skill = 'Sing'
					}					
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Resilient'
					}										
					} ###End if Elf Ranger
					##Rogue Class Skills
					If ($CareerClass -eq "Rogue")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Blather"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Bribery"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Dance'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Dodge Blow'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Flee!'
					}	
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Lightning Reflexes'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Ride'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Silent Move Rural'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Silent Move Urban'
					}
					If ($Roll -ge 81 -and $Roll -le 85)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 86 -and $Roll -le 90)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Street Fighting'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}								
					} #End if Elf Rogue
					###Academic Skills
					If ($CareerClass -eq "Academic")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Astronomy"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Blather"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Cryptography'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Dance'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Etiquette'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Excellent Vision'
					}	
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Flee!'
					}
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Heraldry'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Lightning Reflexes'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Ride'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Silent Move Rural'
					}
					If ($Roll -ge 81 -and $Roll -le 85)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 86 -and $Roll -le 90)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Super Numerate'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Resilient'
					}							
					} #End if Elf Academic
					$SkillSet += $Skill
				} #End SkillRoll ForEach
				} #End if more thank 2 skills for Elf
	} #Endif Elf
			If ($Race -eq "Dwarf")
			{
				If ($Age -ge 16 -and $Age -le 40)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
				}
				Elseif ($Age -ge 41 -and $Age -le 70)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 1
				}		
				elseif ($Age -ge 71 -and $Age -le 100)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 2
				}
				elseif ($Age -ge 101 -and $Age -le 130)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 1					
				}
				elseif ($Age -ge 131 -and $Age -le 170)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
				}
				elseif ($Age -ge 171 -and $Age -le 190)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 - 1
				}	
				elseif ($Age -ge 191 -and $Age -le 200)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 - 1			
				}
				$Skillarray = 1..$SkillRolls | %{ Get-Random -Minimum 1 -Maximum $(100 + 1) } #Creating array of D100 Rolls
				[array]$SkillSet += "Mining"
				If ($Skillrolls -gt 1)
					{
						$Roll3Skills = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
						If ($Roll3Skills -eq 1)
						{
							$Skill = 'Smithing'
						}
						If ($Roll3Skills -eq 2)
						{
							$Skill = 'Metallurgy'
						}					
					}
				$SkillSet += $Skill
				If ($SkillRolls -gt 2)
				{
				$SkillRolls = $null
				If ($Age -ge 16 -and $Age -le 40)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum ($2 + 1) }
				}
				Elseif ($Age -ge 41 -and $Age -le 70)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum ($2 + 1) }
					$SkillRolls = $SkillRolls1 + 1
				}		
				elseif ($Age -ge 71 -and $Age -le 100)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum ($2 + 1) }
					$SkillRolls = $SkillRolls1 + 2
				}
				elseif ($Age -ge 101 -and $Age -le 130)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum ($2 + 1) }
					$SkillRolls = $SkillRolls1 + 1					
				}
				elseif ($Age -ge 131 -and $Age -le 170)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum ($2 + 1) }
				}
				elseif ($Age -ge 171 -and $Age -le 190)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum ($2 + 1) }
					$SkillRolls = $SkillRolls1 - 1
				}	
				elseif ($Age -ge 191 -and $Age -le 200)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum ($2 + 1) }
					$SkillRolls = $SkillRolls1 - 1			
				}
				$Skillarray = 1..$SkillRolls | %{ Get-Random -Minimum 1 -Maximum $(100 + 1) }
				ForEach ($Roll in $Skillarray)	
				{
					If ($CareerClass -eq "Warrior")
					{
					<#template for skill rolls
					If ($Roll -ge [int] -and le [int])
					{
						$Skill = '[string]'
					}
					#>
					##Warrior Class Skills
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Dance"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Disarm"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Dodge Blow'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Lightning Reflexes'
					}	
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 51 -and $Roll -le 60)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Scale Sheer Surface'
					}				
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 76 -and $Roll -le 90)
					{
						$Skill = 'Very Resilient'
					}
					If ($Roll -ge 91 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}
					} #End if Dwarf Warrior
					###Ranger Class Skills
					If ($CareerClass -eq "Ranger")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Astronomy"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Dance"
					}
					If ($Roll -ge 21 -and $Roll -le 30)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Lightning Reflexes'
					}	
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Orientation'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Sixth Sense'
					}				
					If ($Roll -ge 76 -and $Roll -le 90)
					{
						$Skill = 'Very Resilient'
					}
					If ($Roll -ge 91 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}										
					} ###End if Dwarf Ranger
					##Rogue Class Skills
					If ($CareerClass -eq "Rogue")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Blather"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Bribery"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Dance'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Dodge Blow'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Flee!'
					}	
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Street Fighting'
					}
					If ($Roll -ge 71 -and $Roll -le 90)
					{
						$Skill = 'Very Resilient'
					}
					If ($Roll -ge 91 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}
					} #End if Dwarf Rogue
					###Academic Skills
					If ($CareerClass -eq "Academic")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Blather"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Cryptography"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Dance'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Flee!'
					}	
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Heraldry'
					}
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Silent Move Urban'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Super Numerate'
					}
					If ($Roll -ge 76 -and $Roll -le 90)
					{
						$Skill = 'Very Resilient'
					}
					If ($Roll -ge 91 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}						
					} #End if Dwarf Academic
					$SkillSet += $Skill
				} #End SkillRoll ForEach
				} #End if more thank 2 skills for Dwarf
	} #Endif Dwarf
			If ($Race -eq "Halfling")
			{
				If ($Age -ge 16 -and $Age -le 30)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
				}
				Elseif ($Age -ge 31 -and $Age -le 70)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 + 1
				}		
				elseif ($Age -ge 71 -and $Age -le 100)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
				}
				elseif ($Age -ge 101 -and $Age -le 120)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 - 1					
				}
				elseif ($Age -ge 121 -and $Age -le 140)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
					$SkillRolls = $SkillRolls1 - 2
				}
				$Skillarray = 1..$SkillRolls | %{ Get-Random -Minimum 1 -Maximum $(100 + 1) } #Creating array of D100 Rolls
				[array]$SkillSet += "Cook"
				If ($Skillrolls -gt 1)
					{
						$Roll3Skills = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
						If ($Roll3Skills -eq 1)
						{
							$Skill = 'Herb Lore'
						}
						If ($Roll3Skills -eq 2)
						{
							$Skill = 'Specialist Weapon - Sling'
						}
						If ($Roll3Skills -eq 3)
						{
							$Skill = 'Silent Move Rural'
						}						
					}
				$SkillSet += $Skill
				If ($SkillRolls -gt 2)
				{
				$SkillRolls = $null
				If ($Age -ge 16 -and $Age -le 30)
				{
					$SkillRolls = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
				}
				Elseif ($Age -ge 31 -and $Age -le 70)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
					$SkillRolls = $SkillRolls1 + 1
				}		
				elseif ($Age -ge 71 -and $Age -le 100)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
				}
				elseif ($Age -ge 101 -and $Age -le 120)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
					$SkillRolls = $SkillRolls1 - 1					
				}
				elseif ($Age -ge 121 -and $Age -le 140)
				{
					$SkillRolls1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
					$SkillRolls = $SkillRolls1 - 2
				}
				$Skillarray = 1..$SkillRolls | %{ Get-Random -Minimum 1 -Maximum $(100 + 1) }
				ForEach ($Roll in $Skillarray)	
				{
					If ($CareerClass -eq "Warrior")
					{
					<#template for skill rolls
					If ($Roll -ge [int] -and le [int])
					{
						$Skill = '[string]'
					}
					#>
					##Warrior Class Skills
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Dance"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Disarm"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Dodge Blow'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Lightning Reflexes'
					}	
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 56 -and $Roll -le 65)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Silent Move Rural'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Silent Move Urban'
					}					
					If ($Roll -ge 81 -and $Roll -le 90)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Resilient'
					}
					} #end if Halfling warrior
					###Ranger Class Skills
					If ($CareerClass -eq "Ranger")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Astronomy"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Dance"
					}
					If ($Roll -ge 21 -and $Roll -le 30)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Fleet Footed'
					}
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Lightning Reflexes'
					}	
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Orientation'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Prepare Poisons (Herbal)'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Silent Move Rural'
					}
					If ($Roll -ge 81 -and $Roll -le 85)
					{
						$Skill = 'Sing'
					}					
					If ($Roll -ge 86 -and $Roll -le 90)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Very Resilient'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}											
					} ###End if Halfling Ranger
					##Rogue Class Skills
					If ($CareerClass -eq "Rogue")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Blather"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Bribery"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Dance'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Dodge Blow'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Excellent Vision'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Flee!'
					}	
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Lightning Reflexes'
					}
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Night Vision'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Scale Sheer Surface'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Silent Move Rural'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Silent Move Urban'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Street Fighting'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Very Resilient'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}								
					} #End if Halfling Rogue
					###Academic Skills
					If ($CareerClass -eq "Academic")
					{
					If ($Roll -ge 1 -and $Roll -le 5)
					{
						$Skill = 'Acute Hearing'
					}
					If ($Roll -ge 6 -and $Roll -le 10)
					{
						$Skill = "Ambidextrous"
					}
					If ($Roll -ge 11 -and $Roll -le 15)
					{
						$Skill = "Astronomy"
					}
					If ($Roll -ge 16 -and $Roll -le 20)
					{
						$Skill = "Blather"
					}
					If ($Roll -ge 21 -and $Roll -le 25)
					{
						$Skill = 'Cryptography'
					}
					If ($Roll -ge 26 -and $Roll -le 30)
					{
						$Skill = 'Dance'
					}
					If ($Roll -ge 31 -and $Roll -le 35)
					{
						$Skill = 'Drive Cart'
					}
					If ($Roll -ge 36 -and $Roll -le 40)
					{
						$Skill = 'Excellent Vision'
					}	
					If ($Roll -ge 41 -and $Roll -le 45)
					{
						$Skill = 'Flee!'
					}
					If ($Roll -ge 46 -and $Roll -le 50)
					{
						$Skill = 'Heraldry'
					}
					If ($Roll -ge 51 -and $Roll -le 55)
					{
						$Skill = 'Lightning Reflexes'
					}
					If ($Roll -ge 56 -and $Roll -le 60)
					{
						$Skill = 'Luck'
					}
					If ($Roll -ge 61 -and $Roll -le 65)
					{
						$Skill = 'Read/Write'
					}
					If ($Roll -ge 66 -and $Roll -le 70)
					{
						$Skill = 'Silent Move Rural'
					}
					If ($Roll -ge 71 -and $Roll -le 75)
					{
						$Skill = 'Silent Move Urban'
					}
					If ($Roll -ge 76 -and $Roll -le 80)
					{
						$Skill = 'Sing'
					}
					If ($Roll -ge 81 -and $Roll -le 85)
					{
						$Skill = 'Sixth Sense'
					}
					If ($Roll -ge 86 -and $Roll -le 90)
					{
						$Skill = 'Super Numerate'
					}
					If ($Roll -ge 91 -and $Roll -le 95)
					{
						$Skill = 'Very Resilient'
					}
					If ($Roll -ge 96 -and $Roll -le 100)
					{
						$Skill = 'Very Strong'
					}							
					} #End if Dwarf Academic
					$SkillSet += $Skill
				} #End SkillRoll ForEach
				} #End if more thank 2 skills for Dwarf
	} #Endif Dwarf		
					<#Area for checking for duplicate skills.
					If ($SkillSet[0].Equals($SkillSet[1]) -or $SkillSet[0].Equals($SkillSet[2]) -or  $SkillSet[0].Equals($SkillSet[3]) -or $SkillSet[0].Equals($SkillSet[4]) -or $SkillSet[0].Equals($SkillSet[5]) -or  $SkillSet[0].Equals($SkillSet[6]))
				{
					$SkillSet[0] = "Re-Roll"
				}
					If ($SkillSet[1].Equals($SkillSet[2]) -or $SkillSet[1].Equals($SkillSet[3]) -or  $SkillSet[1].Equals($SkillSet[4]) -or $SkillSet[1].Equals($SkillSet[5]) -or $SkillSet[1].Equals($SkillSet[6]) -or  $SkillSet[1].Equals($SkillSet[0]))
				{
					$SkillSet[1] = "Re-Roll"
				}
					If ($SkillSet[2].Equals($SkillSet[3]) -or $SkillSet[2].Equals($SkillSet[4]) -or  $SkillSet[2].Equals($SkillSet[5]) -or $SkillSet[2].Equals($SkillSet[6]) -or $SkillSet[2].Equals($SkillSet[0]) -or  $SkillSet[2].Equals($SkillSet[1]))
				{
					$SkillSet[2] = "Re-Roll"
				}		
					If ($SkillSet[3].Equals($SkillSet[4]) -or $SkillSet[3].Equals($SkillSet[5]) -or  $SkillSet[3].Equals($SkillSet[6]) -or $SkillSet[3].Equals($SkillSet[0]) -or $SkillSet[3].Equals($SkillSet[1]) -or  $SkillSet[3].Equals($SkillSet[2]))
				{
					$SkillSet[3] = "Re-Roll"
				}
					If ($SkillSet[4].Equals($SkillSet[5]) -or $SkillSet[4].Equals($SkillSet[6]) -or  $SkillSet[4].Equals($SkillSet[0]) -or $SkillSet[4].Equals($SkillSet[1]) -or $SkillSet[4].Equals($SkillSet[2]) -or  $SkillSet[4].Equals($SkillSet[3]))
				{
					$SkillSet[4] = "Re-Roll"
				}
					If ($SkillSet[5].Equals($SkillSet[6]) -or $SkillSet[5].Equals($SkillSet[0]) -or  $SkillSet[5].Equals($SkillSet[1]) -or $SkillSet[5].Equals($SkillSet[2]) -or $SkillSet[5].Equals($SkillSet[3]) -or  $SkillSet[4].Equals($SkillSet[5]))
				{
					$SkillSet[5] = "Re-Roll"
				}
				ForEach ($dup in $SkillSet)
				{
					If ($dup -eq "Re-Roll")
					{
						##insert function of skill chart rolling
						[array]$duplicates += $dup
						$rerollnumber = $duplicates.count
						$Reskill = Get-RerollSkills $Race $CareerClass $rerollnumber
						$SkillSet += $Reskill
					}
				}
				#>									
				##Need to implelemnt a check if skill was rolled already.
				<#If ($SkillSet[0] -eq $SkillSet[1] -or -eq $SkillSet[2] -or)
				{
					Write-Output "Duplicate Skills"
					$Duplicate = "Duplicate Skills"
				}#>
						$Skills = New-Object -TypeName PSOBject
		$Skills | Add-Member -MemberType NoteProperty -Name SkillRolls -Value $SkillRolls
		$Skills | Add-Member -MemberType NoteProperty -Name Skillarray -Value $Skillarray
		$Skills | Add-Member -MemberType NoteProperty -Name Skills -Value $Skillset
		$Skills
			} #End Process
} #End function
###
<#Warrior Skill List
Human
01-05 Acute Hearing
06-10 Ambidextrous
11-15 Dance
16-20 Disarm
21-25 Dodge Blow
26-30 Drive Cart
31-35 Excellent Vision
36-40 Fleet Footed
41-45 Lightning Reflexes
46-50 Luck
51-55 Night Vision
56-65 Read/Write
66-75 Ride
76-80 Scale Sheer Surface
81-85 Sing
86-90 Sixth Sense
91-95 Very Resilient
96-100 Very Strong
#>