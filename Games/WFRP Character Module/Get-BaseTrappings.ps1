Function Get-BaseTrappings
{
		param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True)]
		$CareerClass
	)
	PROCESS 
	{
		If ($CareerClass -eq "Warrior")
		{
			$BagRoll = 1..1 | % {Get-Random -Minimum 1 -Maximum $(3 + 1) }
			$HandRoll = 1..1 | % {Get-Random -Minimum 1 -Maximum $(3 + 1)}
			If ($BagRoll -eq 1)
			{
				$Bag = "Slingbag"
			}
			If ($BagRoll -eq 2)
			{
				$Bag = "Backpack"
			}
			If ($BagRoll -eq 3)
			{
				$Bag = "Sack"
			}
			If ($HandRoll -eq 1)
			{
				$Hand = "Sword"
			}
			If ($HandRoll -eq 2)
			{
				$Hand = "Mace"
			}
			If ($HandRoll -eq 3)
			{
				$Hand = "Axe"
			}  
			$Trappings = "Suit of sturdy practical clothing including a hooded cloak and boots, $Bag containing a pewter tankard and cutlery, a tinderbox and a blanket, Purse,"
			$MeleeWeapons = "$Hand, Knife"
		}
		If ($CareerClass -eq "Ranger")
		{
			$blankets = 1..1 | % {Get-Random -Minimum 1 -Maximum $(3 + 1)}
			$BagRoll = 1..1 | % {Get-Random -Minimum 1 -Maximum $(2 + 1) }
			$HandRoll = 1..1 | % {Get-Random -Minimum 1 -Maximum $(2 + 1)}
			$PurseRoll = 1..1 | % {Get-Random -Minimum 1 -Maximum $(2 + 1)}
			If ($BagRoll -eq 1)
			{
				$Bag = "Leather bag"
			}
			If ($BagRoll -eq 2)
			{
				$Bag = "Backpack"
			}
			If ($HandRoll -eq 1)
			{
				$Hand = "Sword"
			}
			If ($HandRoll -eq 2)
			{
				$Hand = "Axe"
			}
			If ($PurseRoll -eq 1)
			{
				$Purse = "Purse"
			}
			If ($PurseRoll -eq 2)
			{
				$Purse = "Money belt"
			}  
			$Trappings = "Suit of good, but weather-worn and travel-stained clothing including a tatty hat, hooded cloak and thick boots. $Bag containing $blankets blankets, cutlery, a tinderbox and a small cooking pot. Flask of water. Knife sheath, $Purse,"
			$MeleeWeapons = "$Hand, Knife"
		}
		If ($CareerClass -eq "Rogue")
		{
			$FootRoll = 1..1 | % {Get-Random -Minimum 1 -Maximum $(2 + 1)}
			If ($FootRoll -eq 1)
			{
				$FootWear = "boots"
			}
			If ($FootRoll -eq 2)
			{
				$FootWear = "shoes"
			}
			$Trappings = "Suit of sturdy worn clothing including $FootWear. Purse,"
			$MeleeWeapons = "Knife"
		}
		If ($CareerClass -eq "Academic")
		{
			$FootRoll = 1..1 | % {Get-Random -Minimum 1 -Maximum $(2 + 1)}
			If ($FootRoll -eq 1)
			{
				$FootWear = "boots"
			}
			If ($FootRoll -eq 2)
			{
				$FootWear = "shoes"
			}
			$Trappings = "Suit of decent light-weight clothes including $FootWear. Purse,"
			$MeleeWeapons = "Knife"
		}
		$Roll1 = 1..1 | % {Get-Random -Minimum 1 -Maximum $(6 + 1)}
		$Roll2 = 1..1 | % {Get-Random -Minimum 1 -Maximum $(6 + 1)}
		$Roll3 = 1..1 | % {Get-Random -Minimum 1 -Maximum $(6 + 1)}
		$Gold = $Roll1 + $Roll2 + $Roll3
		$Wealth = "$Gold"
		$TrappingsObj = New-Object -TypeName PSObject
		$TrappingsObj | Add-Member -MemberType NoteProperty -Name Trappings -Value $Trappings
		$TrappingsObj | Add-Member -MemberType NoteProperty -Name MeleeWeapons -Value $MeleeWeapons
		$TrappingsObj | Add-Member -MemberType NoteProperty -Name Wealth -Value $Wealth
		$TrappingsObj
	}
}