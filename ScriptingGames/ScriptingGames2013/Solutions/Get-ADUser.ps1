#Has flaws when determining account enabled or not.

$Object = [adsi]'LDAP://OU=Sales,OU=UserAccounts,DC=FABRIKAM,DC=COM'

$Searcher = New-Object DirectoryServices.DirectorySearcher
$Searcher.Filter = '(objectCategory=person)'
$Searcher.SearchRoot = 'LDAP://OU=Sales,OU=UserAccounts,DC=FABRIKAM,DC=COM'
$users = $Searcher.FindAll()
$FinUser = $null
$UserResults = $null
$AccountControl = $null

$Locked = $null
ForEach($user in $users)
{
	$SamAccountName = $($user.Properties.samaccountname)
	$Department = $($user.Properties.department)
	$Title = $($user.Properties.title)
	$LastLogOn = [datetime]::FromFileTime([string]$user.Properties.lastlogontimestamp)
	$PasswordLastChanged = [datetime]::FromFileTime([string]$user.Properties.pwdlastset)
	$AccountControl = $($user.Properties.useraccountcontrol)
	$Enable = $Null
	If($AccountControl -eq 512)
	{
		$Enable = "Account enabled."
	}
	ElseIf($AccountControl -eq 514)
	{
		$Enable = "Account disabled."
	}
	ElseIf($AccountControl -eq 66048)
	{
		$Enable = "Account enabled, password never expires."
	}
	ElseIf($AccountControl -eq 66050)
	{
		$Enable = "Account disabled, password never expires"
	}
	If($user.Properties.lockoutcount)
	{
		If($user.Properties.lockoutcount -ge 1)
		{
			$Locked = $True
		}
	}
	$props = @{
		UserName=$SamAccountName
		Department=$Department
		Title=$Title
		LastLogOn=$LastLogOn
		DatePasswordChanged=$PasswordLastChanged
		AccountEnabled=$Enable		
	}
	$UserResults = New-Object –TypeName PSObject –Property $props
	If($Locked)
	{
		$UserResults | Add-Member NoteProperty -Name AccountLocked -Value $Locked
	}
	[array]$FinUser += $UserResults
}

<#
66048 = Enabled, password never expires
66050 = Disabled, password never expires
#>