function Generate-Character
{
$Race = Read-Host "What race? (Human, Elf, Dwarf, Halfling)"
$PCName = Read-Host "Enter a Name (Enter Random for random name)"
$Gender = Read-Host "Male or Female?"
$OldYoung = Read-Host "Young or Old?"
	If ($Race -eq "Human") 
	{
		$M1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$M = $M1 + 2
		$WS1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$WS2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$WS = $WS1 + $WS2 + 20
		$BS1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$BS2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$BS = $BS1 + $BS2 + 20
		$S1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$S = $S1 + 1
		$T1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$T = $T1 + 1
		$W1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$W = $W1 + 4
		$I1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$I2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$I = $I1 + $I2 + 20
		$A = 1
		$Dex1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Dex2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Dex = $Dex1 + $Dex2 + 20
		$Ld1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Ld2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Ld = $Ld1 + $Ld2 + 20
		$Int1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Int2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Int = $Int1 + $Int2 + 20
		$Cl1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Cl2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Cl = $Cl1 + $Cl2 + 20
		$Wp1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Wp2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Wp = $Wp1 + $Wp2 + 20
		$Fel1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Fel2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Fel = $Fel1 + $Fel2 + 20
		$Height1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		If ($Gender -eq "Male") 
			{
				$Height = $Height1 + 64
			}
			elseif ($Gender -eq "Female")
			{
				$Height = $Height1 + 60
			}
		$Alignment = "Neutral"
		$Psychology = "No special psychology rules"
		If ($OldYoung -eq "Young")
			{
				$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age = $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6
				If ($Age -lt 16)
				{
					$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
					$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
					$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
					$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
					$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
					$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
					$Age = $Age + $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6
				} 
			}
		Elseif ($OldYoung -eq "Old")
		{
			$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
			$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
			$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
			$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
			$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
			$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
			$Age = $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6
				If ($Age -lt 16)
				{
					$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
					$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
					$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
					$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
					$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
					$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
					$Age = $Age + $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6	
				}
		}
		$FP1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$FP = $FP1 +1
	}
	elseif ($Race -eq "Elf") 
	{
		$M1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$M = $M1 + 2
		$WS1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$WS2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$WS = $WS1 + $WS2 + 30
		$BS1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$BS2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$BS = $BS1 + $BS2 + 20
		$S1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$S = $S1 + 1
		$T1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$T = $T1 + 1
		$W1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$W = $W1 + 3
		$I1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$I2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$I = $I1 + $I2 + 50
		$A = 1
		$Dex1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Dex2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Dex = $Dex1 + $Dex2 + 30
		$Ld1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Ld2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Ld = $Ld1 + $Ld2 + 30
		$Int1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Int2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Int = $Int1 + $Int2 + 40
		$Cl1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Cl2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Cl = $Cl1 + $Cl2 + 40
		$Wp1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Wp2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Wp = $Wp1 + $Wp2 + 30
		$Fel1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Fel2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Fel = $Fel1 + $Fel2 + 30
		$Height1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		If ($Gender -eq "Male") 
			{
				$Height = $Height1 + 66
			}
			elseif ($Gender -eq "Female")
			{
				$Height = $Height1 + 64
			}
		$Alignment = "Good"
		$Psychology = "No special psychology rules"
		If ($OldYoung -eq "Young")
			{
				$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age10 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age = $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9 + $Age10
				If ($Age -lt 16)
				{
					$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age10 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age = $Age + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9 + $Age10
				} 
			}
		Elseif ($OldYoung -eq "Old")
		{
				$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age10 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age = $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9 + $Age10
				If ($Age -lt 16)
				{
					$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
					$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
					$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
					$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
					$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
					$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
					$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
					$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
					$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
					$Age10 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
					$Age = $Age + $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9 + $Age10	
				}
		}
		$FP1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$FP = $FP1 - 1
		If ($FP -eq 0)
		{
			$FP = 1
		} 
	}
	elseif ($Race -eq "Dwarf")
	{
		$M1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
		$M = $M1 + 2
		$WS1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$WS2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$WS = $WS1 + $WS2 + 30
		$BS1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$BS2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$BS = $BS1 + $BS2 + 10
		$S1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$S = $S1 + 1
		$T1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$T = $T1 + 2
		$W1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$W = $W1 + 5
		$I1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$I2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$I = $I1 + $I2 + 10
		$A = 1
		$Dex1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Dex2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Dex = $Dex1 + $Dex2 + 10
		$Ld1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Ld2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Ld = $Ld1 + $Ld2 + 40
		$Int1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Int2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Int = $Int1 + $Int2 + 20
		$Cl1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Cl2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Cl = $Cl1 + $Cl2 + 40
		$Wp1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Wp2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Wp = $Wp1 + $Wp2 + 40
		$Fel1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Fel2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Fel = $Fel1 + $Fel2 + 10
		$Height1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
			If ($Gender -eq "Male") 
			{
				$Height = $Height1 + 52
			}
			elseif ($Gender -eq "Female")
			{
				$Height = $Height1 + 50
			}
		$Alignment = "Neutral"
		$Psychology = "Hatred for Goblins, Orcs and Hobgoblins. Subject to animosity against Elves."
		If ($OldYoung -eq "Young")
		{
			$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
			$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
			$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
			$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
			$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
			$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
			$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
			$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
			$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
			$Age = $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9
			If ($Age -lt 16)
			{
				$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age = $Age + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9
			} 
		}
		Elseif ($OldYoung -eq "Old")
		{
			$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
			$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
			$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
			$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
			$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
			$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
			$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
			$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
			$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
			$Age = $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9
			If ($Age -lt 16)
			{
				$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(20 + 1) }
				$Age = $Age + $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9
			}
		}
		$FP1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$FP = $FP1
	}
	elseif ($Race -eq "Halfling")
	{
		$M1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(2 + 1) }
		$M = $M1 + 2
		$WS1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$WS2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$WS = $WS1 + $WS2 + 10
		$BS1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$BS2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$BS = $BS1 + $BS2 + 20
		$S1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$S = $S1
		$T1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$T = $T1
		$W1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(3 + 1) }
		$W = $W1 + 3
		$I1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$I2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$I = $I1 + $I2 + 40
		$A = 1
		$Dex1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Dex2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Dex = $Dex1 + $Dex2 + 30
		$Ld1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Ld2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Ld = $Ld1 + $Ld2 + 10
		$Int1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Int2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Int = $Int1 + $Int2 + 20
		$Cl1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Cl2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Cl = $Cl1 + $Cl2 + 10
		$Wp1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Wp2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Wp = $Wp1 + $Wp2 + 30
		$Fel1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Fel2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
		$Fel = $Fel1 + $Fel2 + 30
		$Height1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(10 + 1) }
			If ($Gender -eq "Male") 
			{
				$Height = $Height1 + 40
			}
			elseif ($Gender -eq "Female")
			{
				$Height = $Height1 + 38
			}
		$Alignment = "Neutral"
		$Psychology = "No special psychology rules"
		If ($OldYoung -eq "Young")
		{
			$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
			$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
			$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
			$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
			$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
			$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
			$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
			$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
			$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
			$Age10 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
			$Age = $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9 + $Age10
			If ($Age -lt 16)
			{
				$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age10 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(6 + 1) }
				$Age = $Age + $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9 + $Age10
			}
		}
			Elseif ($OldYoung -eq "Old")
			{
				$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age10 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
				$Age = $Age1 + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9 + $Age10
				If ($Age -lt 16)
				{
					$Age1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age2 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age3 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age4 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age5 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age6 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age7 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age8 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age9 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age10 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(12 + 1) }
					$Age = $Age + $Age2 + $Age3 + $Age4 + $Age5 + $Age6 + $Age7 + $Age8 + $Age9 + $Age10
				} 
			}
		$FP1 = 1..1 | %{ Get-Random -Minimum 1 -Maximum $(4 + 1) }
		$FP = $FP1 
		}
###Implement error check for incorrect race.
##Define class after dice rolls.
###Create custom object of values.
If ($Race -ne "Elf")
{
	If ($WS -ge 30)
	{
		$CareerClassOption1 = "Warrior"
	}
	If ($BS -ge 30)
	{
		$CareerClassOption2 = "Ranger"
	}
	If ($I -ge 30)
	{
		$CareerClassOption3 = "Rogue"
	}
	If ($Int -ge 30 -and $WP -ge 30)
	{
	$CareerClassOption4 = "Academic"
	}
}
If ($Race -eq "Elf")
{
	If ($WS -ge 30)
	{
		$CareerClassOption1 = "Warrior"
	}
	If ($BS -ge 30)
	{
		$CareerClassOption2 = "Ranger"
	}
	If ($I -ge 65)
	{
		$CareerClassOption3 = "Rogue"
	}
	If ($Int -ge 30 -and $WP -ge 30)
	{
	$CareerClassOption4 = "Academic"
	}
}
$CC = $CareerClassOption1, $CareerClassOption2, $CareerClassOption3, $CareerClassOption4
Write-Host "M $M WS $WS BS $BS S $S T $T W $W I $I A $A Dex $Dex Ld $Ld Int $Int Cl $Cl WP $WP Fel $Fel"
$CareerClass = Read-Host "Which career class?($CC)"
$BaseTrappings = Get-BaseTrappings $CareerClass
$Skills = Get-InitialSkills $Race $Age $CareerClass
$SkillList = ($Skills.Skills) -join ', '
$BasicCareer = Get-Career $Race $CareerClass
$BaseCareer = $BasicCareer.BasicCareer
#$BaseCareerAdditions = Get-BasicCareerAdditions $BaseCareer
$FinTrappings = $BaseTrappings.Trappings + $BaseCareerAdditions.Trappings
$FinSkills = $SkillList # + $BaseCareerAdditions.Skills
$PC = New-Object -TypeName PSObject
$PC | Add-Member -MemberType NoteProperty -Name Name -Value $PCName
$PC | Add-Member -MemberType NoteProperty -Name Race -Value $Race
$PC | Add-Member -MemberType NoteProperty -Name Gender -Value $Gender
$PC | Add-Member -MemberType NoteProperty -Name CareerClass -Value $CareerClass
$PC | Add-Member -MemberType NoteProperty -Name Alignment -Value $Alignment
$PC | Add-Member -MemberType NoteProperty -Name Age -Value $Age
$PC | Add-Member -MemberType NoteProperty -Name HeightInInches -Value $Height
# $PC | Add-Member -MemberType NoteProperty -Name Weight -Value $NeedsDefined
# $PC | Add-Member -MemberType NoteProperty -Name Hair -Value $NeedsDefined
# $PC | Add-Member -MemberType NoteProperty -Name Eyes -Value $NeedsDefined
# $PC | Add-Member -MemberType NoteProperty -Name Weight -Value $NeedsDefined
$PC | Add-Member -MemberType NoteProperty -Name M -Value $M
$PC | Add-Member -MemberType NoteProperty -Name WS -Value $WS
$PC | Add-Member -MemberType NoteProperty -Name BS -Value $BS
$PC | Add-Member -MemberType NoteProperty -Name S -Value $S
$PC | Add-Member -MemberType NoteProperty -Name T -Value $T
$PC | Add-Member -MemberType NoteProperty -Name W -Value $W
$PC | Add-Member -MemberType NoteProperty -Name I -Value $I
$PC | Add-Member -MemberType NoteProperty -Name A -Value "1"
$PC | Add-Member -MemberType NoteProperty -Name Dex -Value $Dex
$PC | Add-Member -MemberType NoteProperty -Name Ld -Value $Ld
$PC | Add-Member -MemberType NoteProperty -Name Int -Value $Int
$PC | Add-Member -MemberType NoteProperty -Name Cl -Value $Cl
$PC | Add-Member -MemberType NoteProperty -Name Wp -Value $Wp
$PC | Add-Member -MemberType NoteProperty -Name Fel -Value $Fel
# $PC | Add-Member -MemberType NoteProperty -Name AdvanceScheme $BaseCareerAdditons.IntCareerAdvanceScheme
$PC | Add-Member -MemberType NoteProperty -Name Psychology -Value $Psychology
$PC | Add-Member -MemberType NoteProperty -Name FatePoints -Value $FP
$PC | Add-Member -MemberType NoteProperty -Name Skills -Value $FinSkills #Ignore Re-Roll and if a skill duplicates again, manually re-roll that skill.
$PC | Add-Member -MemberType NoteProperty -Name BasicCareer -Value $BaseCareer
$PC | Add-Member -MemberType NoteProperty -Name Trappings -Value $FinTrappings
$PC | Add-Member -MemberType NoteProperty -Name 'Hand To Hand Weapons' -Value $BaseTrappings.MeleeWeapons
$PC | Add-Member -MemberType NoteProperty -Name Wealth -Value $BaseTrappings.Wealth
$PC
$Document = "C:\Scripts\WFRPSheet.pdf"
$Output = "C:\Scripts\$($PC.PCName)Sheet.pdf"
Add-Type -Path ".\itextsharp.dll"
$reader = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $Document
$stamper = New-Object iTextSharp.text.pdf.PdfStamper($reader,[System.IO.File]::Create($Output))
$pdfFields=@{
'Name' = $PC.PCName
'Race' = $PC.Race
'Gender' = $PC.Gender
'CareerClass' = $PC.CareerClass
'Align' = $PC.Alignment
'Age' = $PC.Age
'Height' = $PC.HeightInInches
'Weight' = ""
'Hair' = ""
'Eyes' = ""
'Description' = "" 
'Current Career' = $PC.BasicCareer
'Career Path' = ""
'Career Exits' = ""
'M' = $PC.M
'WS' = $PC.WS
'BS' = $PC.BS
'S' = $PC.S
'T' = $PC.T
'W' = $PC.W
'I' = $PC.I
'A' = $PC.A
'Dex' = $PC.Dex
'Ld' = $PC.Ld
'Int' = $PC.Int
'Cl' = $PC.Cl
'WP' = $PC.Wp
'Fel' = $PC.Fel
'Adv_M' = ""
'Adv_WS' = ""
'Adv_BS' = ""
'Adv_S' = ""
'Adv_T' = ""
'Adv_W' = ""
'Adv_I' = ""
'Adv_A' = ""
'Adv_Dex' = "" 
'Adv_Ld' = ""
'Adv_Int' = ""
'Adv_Cl' = ""
'Adv_Wp' = ""
'Adv_Fel' = ""
'Cur_M' = ""
'Cur_WS' = ""
'Cur_BS' = ""
'Cur_S' = ""
'Cur_T' = ""
'Cur_W' = ""
'Cur_I' = ""
'Cur_A' = ""
'Cur_Dex' = ""
'Cur_Ld' = ""
'Cur_Int' = ""
'Cur_Cl' = ""
'Cur_Wp' = ""
'Cur_Fel' = ""
'1st Advance_W' = "" 
'2nd Advance_W' = ""
'3rd Advance_W' = ""
'4th Advance_W' = ""
'1st Advance_M' = ""
'2nd Advance_M' = ""
'3rd Advance_M' = ""
'4th Advance_M' = ""
'1st Advance_WS' = ""
'2nd Advance_WS' = ""
'3rd Advance_WS' = ""
'4th Advance_WS' = ""
'1st Advance_BS' = ""
'2nd Advance_BS' = ""
'3rd Advance_BS' = ""
'4th Advance_BS' = ""
'1st Advance_S' = ""
'2nd Advance_S' = ""
'3rd Advance_S' = ""
'4th Advance_S' = ""
'1st Advance_T' = ""
'2nd Advance_T' = ""
'3rd Advance_T' = ""
'4th Advance_T' = ""
'1st Advance_I' = ""
'2nd Advance_I' = ""
'3rd Advance_I' = ""
'4tht Advance_I' = ""
'1st Advance_A' = ""
'2nd Advance_A' = ""
'3 rdAdvance_A' = ""
'1st Advance_Cl' = ""
'2nd Advance_Cl' = ""
'3rd Advance_Cl' = ""
'4th Advance_Cl' = ""
'1st Advance_Wp' = ""
'2nd Advance_Wp' = ""
'3rd Advance_Wp' = ""
'4th Advance_Wp' = ""
'5th Advance_W' = ""
'6th Advance_W' = ""
'7th Advance_W' = ""
'8th Advance_W' = ""
'1st Advance_Dex' = "" 
'2nd Advance_Dex' = ""
'3rd Advance_Dex' = ""
'4th Advance_Dex' = ""
'1st Advance_Ld' = ""
'2nd Advance_Ld' = ""
'3rd Advance_Ld' = ""
'4th Advance_Ld' = ""
'1st Advance_Int' = ""
'2nd Advance_Int' = ""
'3rd Advance_Int' = ""
'4th Advance_Int' = ""
'1st Advance_Fel' = ""
'2nd Advance_Fel' = ""
'3rd Advance_Fel' = ""
'4th Advance_Fel' = ""
'Skills_1st Field' = ""
'Skill Effect_Field1' = ""
'Skills' = $PC.Skills
'Skill Effect' = ""
'H2H_Weaps' = $PC.'Hand To Hand Weapons'
'H2H_Weaps_I' = ""
'H2H_Weaps_WS' = ""
'H2H_Weaps_D' = ""
'H2H_Weaps_PY' = ""
'Missile_Weaps' = ""
'Missile_Weaps_S' = ""
'Missile_Weaps_L' = ""
'Missile_Weaps_E' = ""
'Missile_Weaps_ES' = ""
'Missile_Weaps_Load' = ""
'AP_Shield' = ""
'AP_RArm' = ""
'AP_Head' = ""
'Armour' = ""
'Armour_loc' = "" 
'Armour_Enc' = ""
'AP_Body' = ""
'AP_LArm' = ""
'AP_RLeg' = ""
'AP_LLeg' = ""
'Spells' = ""
'Spells_SL' = "" 
'Spells_MP' = ""
'Spells_R' = ""
'Spells_D' = ""
'Spells_Ing' = ""
'Spells_Effect' = "" 
'FP' = $PC.FatePoints
'MP' = ""
'PL' = ""
'MR_1Cat' = "" 
'MR_2Cat' = ""
'MR_3Cat' = ""
'MR_1Stnd' = ""
'MR_2Stnd' = ""
'MR_3Stnd' = ""
'MR_1Run' = ""
'MR_2Run' = ""
'MR_3Run' = ""
'Langs' = ""
'Psych' = $PC.Psychology
'IP' = ""
'Birth' = "" 
'Parents' = ""
'Siblings' = ""
'Social' = ""
'Religion' = ""
'Trapps' = $PC.Trappings
'Trapps_LOC' = "" 
'Trapps_ENC' = ""
'Trap_ENC_Tot' = "" 
'EXP' = ""
'Wealth' = $PC.Wealth
'Wealth_LOC' = "" 
'Wealth_ENC' = ""
'Wealth_ENC_Tot' = "" 
'Comp_Anim' = ""
'Comp_Anim_M' = ""
'Comp_Anim_WS' = ""
'Comp_Anim_BS' = ""
'Comp_Anim_S' = ""
'Comp_Anim_T' = ""
'Comp_Anim_W' = ""
'Comp_Anim_I' = ""
'Comp_Anim_A' = ""
'Comp_Anim_Dex' = "" 
'Comp_Anim_Ld' = ""
'Comp_Anim_Int' = ""
'Comp_Anim_Cl' = ""
'Comp_Anim_Wp' = "" 
'Comp_Anim_Fel' = ""
}
ForEach ($field in $pdfFields.GetEnumerator())
{
	$stamper.AcroFields.SetField($field.Key, $field.Value) | Out-Null 
}
$stamper.close()  
}