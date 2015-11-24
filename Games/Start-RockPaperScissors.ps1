Function Start-RockPaperScissors
{
	param
	(
		[Parameter(Position=0,Mandatory=$True)]$Choice		
	)
	begin{}
	process
	{
		$val = Get-Random -Minimum 1 -Maximum 100
		If($val -ge 1 -and $val -le 33)
		{
			$computer = "Rock"
		}
		If($val -ge 34 -and $val -le 66)
		{
			$computer = "Paper"
		}
		If($val -ge 67 -and $val -le 100)
		{
			$computer = "Scissors" 			
		}
		If($Choice -like "*Rock*")
		{
			If($Computer -like "*Paper*")
			{
				"Paper covers rock. You lost."
			}
			If($Computer -like "*Scissors")
			{
				"Rock crushes scissors. You won!"
			}
			If($Computer -like "*Rock*")
			{
				"Both had rock. You tied."
			}
		}
		If($Choice -like "*Paper*")
		{
			If($Computer -like "*Paper*")
			{
				"Both had paper. You tied."				
			}
			If($Computer -like "*Scissors")
			{
				"Scissors cuts paper. You lost."
			}
			If($Computer -like "*Rock*")
			{
				"Paper covers rock. You won!"
			}			
		}
		If($Choice -like "*Scissors*")
		{
			If($Computer -like "*Paper*")
			{
				"Scissors cuts paper. You won!"
			}
			If($Computer -like "*Scissors")
			{
				"Both had scissors. You tied."
			}
			If($Computer -like "*Rock*")
			{
				"Rock crushes scissors. You lost."
			}			
		}
		
	}
}