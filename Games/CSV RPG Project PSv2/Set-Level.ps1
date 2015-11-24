Function Set-Level
{
	param
	(
		[Parameter(Mandatory=$False)]
		[string]$Path = "$($ENV:USERPROFILE)\Documents",
		[Parameter(Mandatory=$True]
		$Level
	)
	Begin
	{
		$pcdb = "Import-CSV $($Path)\pcdb.txt"
	}
	Process
	{
		$picks = Read-Host "Pick your statistics to upgrade"
	}
}