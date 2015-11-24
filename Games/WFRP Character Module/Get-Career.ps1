Function Get-Career
{
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True)]
		$Race,
		$CareerClass
	)
	PROCESS 
	{
		$Dieroll = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(100 + 1) }
		If ($Race -eq "Human")
		{
			If ($CareerClass -eq "Warrior")
			{
				<#template
				If ($Dieroll -ge [int] -and $Dieroll -le [int])
				{
					$BasicCareer = '[string]'
				}
				#>
				If ($Dieroll -ge 1 -and $Dieroll -le 10)
				{
					$BasicCareer = 'Bodyguard'
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 20)
				{
					$BasicCareer = 'Labourer'
				}
				If ($Dieroll -ge 21 -and $Dieroll -le 25)
				{
					$BasicCareer = 'Marine'
				}
				If ($Dieroll -ge 26 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Mercenary'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Militiaman'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 45)
				{
					$BasicCareer = 'Noble'
				}
				If ($Dieroll -ge 46 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Outlaw'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 60)
				{
					$BasicCareer = 'Pit Fighter'
				}
				If ($Dieroll -ge 61 -and $Dieroll -le 65)
				{
					$BasicCareer = 'Protagonist'
				}
				If ($Dieroll -ge 66 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Seaman'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 80)														
				{
					$BasicCareer = 'Servant'
				}
				If ($Dieroll -ge 81 -and $Dieroll -le 90)
				{
					$BasicCareer = 'Soldier'
				}
				If ($Dieroll -ge 91 -and $Dieroll -le 95)
				{
					$BasicCareer = 'Squire'
				}
				If ($Dieroll -ge 96 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Watchman'
				}															
			} #End if Human Warrior
			If ($CareerClass -eq "Ranger")
			{
				<#template
				If ($Dieroll -ge [int] -and $Dieroll -le [int])
				{
					$BasicCareer = '[string]'
				}
				#>
				If ($Dieroll -ge 1 -and $Dieroll -le 5)
				{
					$BasicCareer = 'Boatman'
				}
				If ($Dieroll -ge 6 -and $Dieroll -le 10)
				{
					$BasicCareer = 'Bounty Hunter'
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 15)
				{
					$BasicCareer = 'Coachman'
				}
				If ($Dieroll -ge 16 -and $Dieroll -le 20)
				{
					$BasicCareer = 'Fisherman'
				}
				If ($Dieroll -ge 21 -and $Dieroll -le 30)
				{
					$BasicCareer = 'Gamekeeper'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Herdsman'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 45)
				{
					$BasicCareer = 'Hunter'
				}
				If ($Dieroll -ge 46 -and $Dieroll -le 50)
				{
					$BasicCareer = 'Muleskinner'
				}
				If ($Dieroll -ge 51 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Outrider'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 60)
				{
					$BasicCareer = 'Pilot'
				}
				If ($Dieroll -ge 61 -and $Dieroll -le 65)
				{
					$BasicCareer = 'Prospector'
				}
				If ($Dieroll -ge 66 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Rat Catcher'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 75)
				{
					$BasicCareer = 'Roadwarden'
				}
				If ($Dieroll -ge 76 -and $Dieroll -le 80)
				{
					$BasicCareer = 'Toll-Keeper'
				}
				If ($Dieroll -ge 81 -and $Dieroll -le 90)
				{
					$BasicCareer = 'Trapper'
				}
				If ($Dieroll -ge 91 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Woodsman'
				}							
			} #End if Human Ranger
			If ($CareerClass -eq "Rogue")
			{
				<#template
				If ($Dieroll -ge [int] -and $Dieroll -le [int])
				{
					$BasicCareer = '[string]'
				}
				#>
				If ($Dieroll -ge 1 -and $Dieroll -le 5)
				{
					$BasicCareer = 'Agitator'
				}
				If ($Dieroll -ge 6 -and $Dieroll -le 15)
				{
					$BasicCareer = 'Bawd'
				}
				If ($Dieroll -ge 16 -and $Dieroll -le 25)
				{
					$BasicCareer = 'Beggar'
				}
				If ($Dieroll -ge 26 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Entertainer'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 45)
				{
					$BasicCareer = 'Footpad'
				}
				If ($Dieroll -ge 46 -and $Dieroll -le 50)
				{
					$BasicCareer = 'Gambler'
				}
				If ($Dieroll -ge 51 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Grave Robber'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 60)
				{
					$BasicCareer = 'Jailer'
				}
				If ($Dieroll -ge 61 -and $Dieroll -le 65)
				{
					$BasicCareer = 'Pedlar'
				}	
				If ($Dieroll -ge 66 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Raconteur'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 75)
				{
					$BasicCareer = 'Rustler'
				}
				If ($Dieroll -ge 76 -and $Dieroll -le 80)
				{
					$BasicCareer = 'Smuggler'
				}			
				If ($Dieroll -ge 81 -and $Dieroll -le 95)
				{
					$BasicCareer = 'Thief'
				}
				If ($Dieroll -ge 96 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Tomb Robber'
				}
			} #End if Human Rogue
			If ($CareerClass -eq "Academic")
			{
				<#template
				If ($Dieroll -ge [int] -and $Dieroll -le [int])
				{
					$BasicCareer = '[string]'
				}
				#>
				If ($Dieroll -ge 1 -and $Dieroll -le 10)
				{
					$BasicCareer = "Alchemist`'s Apprentice"
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 20)
				{
					$BasicCareer = "Artisan`'s Apprentice"
				}
				If ($Dieroll -ge 21 -and $Dieroll -le 25)
				{
					$BasicCareer = 'Druid'
				}
				If ($Dieroll -ge 26 -and $Dieroll -le 30)
				{
					$BasicCareer = 'Exciseman'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Herbalist'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Hypnotist'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 50)
				{
					$BasicCareer = 'Initiate'
				}
				If ($Dieroll -ge 51 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Pharmacist'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 60)
				{
					$BasicCareer = "Physician`'s Student"
				}	
				If ($Dieroll -ge 61 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Scribe'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 75)
				{
					$BasicCareer = 'Seer'
				}
				If ($Dieroll -ge 76 -and $Dieroll -le 80)
				{
					$BasicCareer = 'Student'
				}			
				If ($Dieroll -ge 81 -and $Dieroll -le 90)
				{
					$BasicCareer = 'Trader'
				}
				If ($Dieroll -ge 91 -and $Dieroll -le 100)
				{
					$BasicCareer = "Wizard`'s Apprentice"
				}				
			} #End if Human Academic
		} #End if Human
		elseif ($Race -eq "Elf")
		{
			If ($CareerClass -eq "Warrior")
			{
				<#template
				If ($Dieroll -ge [int] -and $Dieroll -le [int])
				{
					$BasicCareer = '[string]'
				}
				#>
				If ($Dieroll -ge 1 -and $Dieroll -le 10)
				{
					$BasicCareer = 'Bodyguard'
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 20)
				{
					$BasicCareer = 'Marine'
				}
				If ($Dieroll -ge 21 -and $Dieroll -le 30)
				{
					$BasicCareer = 'Mercenary'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Militiaman'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 45)
				{
					$BasicCareer = 'Noble'
				}
				If ($Dieroll -ge 46 -and $Dieroll -le 50)
				{
					$BasicCareer = 'Outlaw'
				}
				If ($Dieroll -ge 51 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Protagonist'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 65)
				{
					$BasicCareer = 'Seaman'
				}
				If ($Dieroll -ge 66 -and $Dieroll -le 70)														
				{
					$BasicCareer = 'Servant'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 85)
				{
					$BasicCareer = 'Soldier'
				}
				If ($Dieroll -ge 86 -and $Dieroll -le 95)
				{
					$BasicCareer = 'Squire'
				}
				If ($Dieroll -ge 96 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Watchman'
				}				
			} #End if Elf Warrior
			If ($CareerClass -eq "Ranger")
			{
				<#template
				If ($Dieroll -ge [int] -and $Dieroll -le [int])
				{
					$BasicCareer = '[string]'
				}
				#>
				If ($Dieroll -ge 1 -and $Dieroll -le 10)
				{
					$BasicCareer = 'Boatman'
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 15)
				{
					$BasicCareer = 'Bounty Hunter'
				}
				If ($Dieroll -ge 16 -and $Dieroll -le 20)
				{
					$BasicCareer = 'Coachman'
				}
				If ($Dieroll -ge 21 -and $Dieroll -le 30)
				{
					$BasicCareer = 'Fisherman'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Gamekeeper'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 50)
				{
					$BasicCareer = 'Herdsman'
				}
				If ($Dieroll -ge 51 -and $Dieroll -le 60)
				{
					$BasicCareer = 'Hunter'
				}
				If ($Dieroll -ge 61 -and $Dieroll -le 65)
				{
					$BasicCareer = 'Muleskinner'
				}
				If ($Dieroll -ge 66 -and $Dieroll -le 75)
				{
					$BasicCareer = 'Outrider'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 80)
				{
					$BasicCareer = 'Pilot'
				}
				If ($Dieroll -ge 81 -and $Dieroll -le 90)
				{
					$BasicCareer = 'Trapper'
				}
				If ($Dieroll -ge 91 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Woodsman'
				}					
			} #End if Elf Ranger
			If ($CareerClass -eq "Rogue")
			{
				If ($Dieroll -ge 1 -and $Dieroll -le 5)
				{
					$BasicCareer = 'Agitator'
				}
				If ($Dieroll -ge 6 -and $Dieroll -le 10)
				{
					$BasicCareer = 'Bawd'
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 25)
				{
					$BasicCareer = 'Entertainer'
				}
				If ($Dieroll -ge 26 -and $Dieroll -le 30)
				{
					$BasicCareer = 'Footpad'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Gambler'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 50)
				{
					$BasicCareer = 'Minstrel'
				}
				If ($Dieroll -ge 51 -and $Dieroll -le 60)
				{
					$BasicCareer = 'Pedlar'
				}
				If ($Dieroll -ge 61 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Raconteur'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 75)
				{
					$BasicCareer = 'Rustler'
				}
				If ($Dieroll -ge 76 -and $Dieroll -le 85)
				{
					$BasicCareer = 'Smuggler'
				}			
				If ($Dieroll -ge 86 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Thief'
				}
			} #End if Elf Rogue
			If ($CareerClass -eq "Academic")
			{
				If ($Dieroll -ge 1 -and $Dieroll -le 10)
				{
					$BasicCareer = "Alchemist`'s Apprentice"
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 15)
				{
					$BasicCareer = "Artisan`'s Apprentice"
				}
				If ($Dieroll -ge 16 -and $Dieroll -le 30)
				{
					$BasicCareer = 'Herbalist'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Hypnotist'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Initiate'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 45)
				{
					$BasicCareer = 'Pharmacist'
				}
				If ($Dieroll -ge 46 -and $Dieroll -le 50)
				{
					$BasicCareer = "Physician`'s Student"
				}
				If ($Dieroll -ge 51 -and $Dieroll -le 55)
				{
					$BasicCareer = "Scribe"
				}	
				If ($Dieroll -ge 56 -and $Dieroll -le 65)
				{
					$BasicCareer = 'Seer'
				}
				If ($Dieroll -ge 66 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Student'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 85)
				{
					$BasicCareer = 'Trader'
				}			
				If ($Dieroll -ge 86 -and $Dieroll -le 100)
				{
					$BasicCareer = "Wizard`'s Apprentice"
				}					
			} #End if Elf Academic
		} #End if Elf
		elseif ($Race -eq "Dwarf")
		{
			If ($CareerClass -eq "Warrior")
			{
				If ($Dieroll -ge 1 -and $Dieroll -le 10)
				{
					$BasicCareer = 'Bodyguard'
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 15)
				{
					$BasicCareer = 'Labourer'
				}
				If ($Dieroll -ge 16 -and $Dieroll -le 25)
				{
					$BasicCareer = 'Mercenary'
				}
				If ($Dieroll -ge 26 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Militiaman'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Noble'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 45)
				{
					$BasicCareer = 'Outlaw'
				}
				If ($Dieroll -ge 46 -and $Dieroll -le 50)
				{
					$BasicCareer = 'Pit Fighter'
				}
				If ($Dieroll -ge 51 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Protagonist'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 60)														
				{
					$BasicCareer = 'Servant'
				}
				If ($Dieroll -ge 61 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Soldier'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 75)
				{
					$BasicCareer = 'Squire'
				}
				If ($Dieroll -ge 76 -and $Dieroll -le 85)
				{
					$BasicCareer = 'Troll Slayer'
				}
				If ($Dieroll -ge 86 -and $Dieroll -le 95)
				{
					$BasicCareer = 'Tunnel Fighter'
				}	
				If ($Dieroll -ge 96 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Watchman'
				}		
			}
			If ($CareerClass -eq "Ranger")
			{
				If ($Dieroll -ge 1 -and $Dieroll -le 10)
				{
					$BasicCareer = 'Bounty Hunter'
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 15)
				{
					$BasicCareer = 'Coachman'
				}
				If ($Dieroll -ge 16 -and $Dieroll -le 20)
				{
					$BasicCareer = 'Gamekeeper'
				}
				If ($Dieroll -ge 21 -and $Dieroll -le 25)
				{
					$BasicCareer = 'Hunter'
				}
				If ($Dieroll -ge 26 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Muleskinner'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Prospector'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 65)
				{
					$BasicCareer = 'Rat Catcher'
				}
				If ($Dieroll -ge 66 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Roadwarden'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 85)
				{
					$BasicCareer = 'Runner'
				}
				If ($Dieroll -ge 86 -and $Dieroll -le 90)
				{
					$BasicCareer = 'Toll-Keeper'
				}
				If ($Dieroll -ge 91 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Trapper'
				}
			} #End if Dwarf Ranger
			If ($CareerClass -eq "Rogue")
			{
				If ($Dieroll -ge 1 -and $Dieroll -le 5)
				{
					$BasicCareer = 'Bawd'
				}
				If ($Dieroll -ge 6 -and $Dieroll -le 10)
				{
					$BasicCareer = 'Beggar'
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 15)
				{
					$BasicCareer = 'Entertainer'
				}
				If ($Dieroll -ge 16 -and $Dieroll -le 20)
				{
					$BasicCareer = 'Footpad'
				}
				If ($Dieroll -ge 21 -and $Dieroll -le 25)
				{
					$BasicCareer = 'Gambler'
				}
				If ($Dieroll -ge 26 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Grave Robber'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 45)
				{
					$BasicCareer = 'Jailer'
				}
				If ($Dieroll -ge 46 -and $Dieroll -le 50)
				{
					$BasicCareer = 'Pedlar'
				}
				If ($Dieroll -ge 51 -and $Dieroll -le 56)
				{
					$BasicCareer = 'Raconteur'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 60)
				{
					$BasicCareer = 'Rustler'
				}
				If ($Dieroll -ge 61 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Smuggler'
				}			
				If ($Dieroll -ge 71 -and $Dieroll -le 90)
				{
					$BasicCareer = 'Thief'
				}
				If ($Dieroll -ge 91 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Tomb Robber'
				}
			} #End if Dwarf Rogue
			If ($CareerClass -eq "Academic")
			{
				If ($Dieroll -ge 1 -and $Dieroll -le 10)
				{
					$BasicCareer = "Alchemist`'s Apprentice"
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 20)
				{
					$BasicCareer = "Artisan`'s Apprentice"
				}
				If ($Dieroll -ge 21 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Engineer'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Excisemen'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 45)
				{
					$BasicCareer = 'Initiate'
				}
				If ($Dieroll -ge 46 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Pharmacist'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 60)
				{
					$BasicCareer = "Physician`'s Student"
				}
				If ($Dieroll -ge 61 -and $Dieroll -le 70)
				{
					$BasicCareer = "Scribe"
				}	
				If ($Dieroll -ge 71 -and $Dieroll -le 75)
				{
					$BasicCareer = 'Seer'
				}
				If ($Dieroll -ge 76 -and $Dieroll -le 80)
				{
					$BasicCareer = 'Student'
				}
				If ($Dieroll -ge 81 -and $Dieroll -le 98)
				{
					$BasicCareer = 'Trader'
				}			
				If ($Dieroll -ge 99 -and $Dieroll -le 100)
				{
					$BasicCareer = "Wizard`'s Apprentice"
				}	
			} #End if Dwarf Academic
		}
		elseif ($Race -eq "Halfling")
		{
			If ($CareerClass -eq "Warrior")
			{
				If ($Dieroll -ge 1 -and $Dieroll -le 15)
				{
					$BasicCareer = 'Bodyguard'
				}
				If ($Dieroll -ge 16 -and $Dieroll -le 20)
				{
					$BasicCareer = 'Labourer'
				}
				If ($Dieroll -ge 21 -and $Dieroll -le 30)
				{
					$BasicCareer = 'Militiaman'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Noble'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Outlaw'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Servant'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Soldier'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 80)
				{
					$BasicCareer = 'Pit Fighter'
				}
				If ($Dieroll -ge 61 -and $Dieroll -le 65)
				{
					$BasicCareer = 'Protagonist'
				}
				If ($Dieroll -ge 66 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Seaman'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 80)														
				{
					$BasicCareer = 'Squire'
				}
				If ($Dieroll -ge 81 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Watchman'
				}		
			} #End if Halfling Warrior
			If ($CareerClass -eq "Ranger")
			{
				If ($Dieroll -ge 1 -and $Dieroll -le 5)
				{
					$BasicCareer = 'Coachman'
				}
				If ($Dieroll -ge 6 -and $Dieroll -le 10)
				{
					$BasicCareer = 'Fisherman'
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 20)
				{
					$BasicCareer = 'Gamekeeper'
				}
				If ($Dieroll -ge 21 -and $Dieroll -le 30)
				{
					$BasicCareer = 'Herdsman'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Hunter'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Herdsman'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 50)
				{
					$BasicCareer = 'Muleskinner'
				}
				If ($Dieroll -ge 51 -and $Dieroll -le 65)
				{
					$BasicCareer = 'Rat Catcher'
				}
				If ($Dieroll -ge 66 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Roadwarden'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 75)
				{
					$BasicCareer = 'Toll-Keeper'
				}
				If ($Dieroll -ge 76 -and $Dieroll -le 85)
				{
					$BasicCareer = 'Trapper'
				}
				If ($Dieroll -ge 86 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Woodsman'
				}	
			} #End if Halfling Ranger
			If ($CareerClass -eq "Rogue")
			{
				If ($Dieroll -ge 1 -and $Dieroll -le 5)
				{
					$BasicCareer = 'Agitator'
				}
				If ($Dieroll -ge 6 -and $Dieroll -le 10)
				{
					$BasicCareer = 'Bawd'
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 15)
				{
					$BasicCareer = 'Beggar'
				}
				If ($Dieroll -ge 16 -and $Dieroll -le 25)
				{
					$BasicCareer = 'Entertainer'
				}
				If ($Dieroll -ge 26 -and $Dieroll -le 30)
				{
					$BasicCareer = 'Footpad'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 35)
				{
					$BasicCareer = 'Gambler'
				}
				If ($Dieroll -ge 36 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Grave Robber'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 45)
				{
					$BasicCareer = 'Jailer'
				}
				If ($Dieroll -ge 46 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Pedlar'
				}	
				If ($Dieroll -ge 56 -and $Dieroll -le 65)
				{
					$BasicCareer = 'Raconteur'
				}
				If ($Dieroll -ge 66 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Rustler'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 80)
				{
					$BasicCareer = 'Smuggler'
				}			
				If ($Dieroll -ge 81 -and $Dieroll -le 95)
				{
					$BasicCareer = 'Thief'
				}
				If ($Dieroll -ge 96 -and $Dieroll -le 100)
				{
					$BasicCareer = 'Tomb Robber'
				}
			} #End if Halfling Rogue
			If ($CareerClass -eq "Academic")
			{
				If ($Dieroll -ge 1 -and $Dieroll -le 10)
				{
					$BasicCareer = "Alchemist`'s Apprentice"
				}
				If ($Dieroll -ge 11 -and $Dieroll -le 25)
				{
					$BasicCareer = "Artisan`'s Apprentice"
				}
				If ($Dieroll -ge 26 -and $Dieroll -le 30)
				{
					$BasicCareer = 'Exciseman'
				}
				If ($Dieroll -ge 31 -and $Dieroll -le 40)
				{
					$BasicCareer = 'Herbalist'
				}
				If ($Dieroll -ge 41 -and $Dieroll -le 45)
				{
					$BasicCareer = 'Initiate'
				}
				If ($Dieroll -ge 46 -and $Dieroll -le 55)
				{
					$BasicCareer = 'Pharmacist'
				}
				If ($Dieroll -ge 56 -and $Dieroll -le 60)
				{
					$BasicCareer = "Physician`'s Student"
				}	
				If ($Dieroll -ge 61 -and $Dieroll -le 70)
				{
					$BasicCareer = 'Scribe'
				}
				If ($Dieroll -ge 71 -and $Dieroll -le 75)
				{
					$BasicCareer = 'Seer'
				}
				If ($Dieroll -ge 76 -and $Dieroll -le 80)
				{
					$BasicCareer = 'Student'
				}			
				If ($Dieroll -ge 81 -and $Dieroll -le 98)
				{
					$BasicCareer = 'Trader'
				}
				If ($Dieroll -ge 99 -and $Dieroll -le 100)
				{
					$BasicCareer = "Wizard`'s Apprentice"
				}
			} #End if Halfling Academic
		}
		$BaseCareer = New-Object -TypeName PSObject
		$BaseCareer | Add-Member -MemberType NoteProperty -Name BasicCareer -Value $BasicCareer
		$BaseCareer						
	} #End Process
} #End Function