Function Get-Stats
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Race,
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Name,	
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Gender,
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$OldYoung			
	)
	#OldYoung might be better as a switch parameter.
<#
$Race = Read-Host "What race? (Human, Elf, Dwarf, Halfling)"
$Name = Read-Host "Enter a Name (Enter Random for random name)"
$Gender = Read-Host "Male or Female?"
$OldYoung = Read-Host "Young or Old?"
#>
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
$global:PC = New-Object -TypeName PSObject
$PC | Add-Member -MemberType NoteProperty -Name Name -Value $Name
$PC | Add-Member -MemberType NoteProperty -Name Race -Value $Race
$PC | Add-Member -MemberType NoteProperty -Name Gender -Value $Gender
$PC | Add-Member -MemberType NoteProperty -Name Age -Value $Age
$PC | Add-Member -MemberType NoteProperty -Name HeightInInches -Value $Height
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
}