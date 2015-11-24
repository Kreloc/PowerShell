Function Get-LocalUser  
{
	<#	
		.SYNOPSIS
			The Get-LocalUser function finds and dispalys the local users on the computer specified.
		
		.DESCRIPTION
			The Get-LocalUser function finds and dispalys the local users on the computer specified using ADSI and two helper functions, ConvertTo-SID and Convert-UserFlag.
		
		.PARAMETER ComputerName
			The name of the computer to find local users on.
		
		.EXAMPLE
			PS C:\> Get-LocalUser <ComputerName>
			
		.EXAMPLE
			Get-Content computers.txt | Get-LocalUser
		
		.NOTES
			Downloaded from somewhere, can't remeber the exact source. Contact me at mrince@outlook.com if this script was yours.
	#>	
  [CmdletBinding()]
  Param
  (
    [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [String[]]$Computername =  $Env:Computername
  )
  Begin 
  {
  #region  Helper Functions

  Function  ConvertTo-SID 
  {
  Param([byte[]]$BinarySID)

  (New-Object  System.Security.Principal.SecurityIdentifier($BinarySID,0)).Value

  }

  Function  Convert-UserFlag 
  {

  Param  ($UserFlag)

  $List  = New-Object  System.Collections.ArrayList

  Switch  ($UserFlag) 
  {

  ($UserFlag  -BOR 0x0001)  {[void]$List.Add('SCRIPT')}

  ($UserFlag  -BOR 0x0002)  {[void]$List.Add('ACCOUNTDISABLE')}

  ($UserFlag  -BOR 0x0008)  {[void]$List.Add('HOMEDIR_REQUIRED')}

  ($UserFlag  -BOR 0x0010)  {[void]$List.Add('LOCKOUT')}

  ($UserFlag  -BOR 0x0020)  {[void]$List.Add('PASSWD_NOTREQD')}

  ($UserFlag  -BOR 0x0040)  {[void]$List.Add('PASSWD_CANT_CHANGE')}

  ($UserFlag  -BOR 0x0080)  {[void]$List.Add('ENCRYPTED_TEXT_PWD_ALLOWED')}

  ($UserFlag  -BOR 0x0100)  {[void]$List.Add('TEMP_DUPLICATE_ACCOUNT')}

  ($UserFlag  -BOR 0x0200)  {[void]$List.Add('NORMAL_ACCOUNT')}

  ($UserFlag  -BOR 0x0800)  {[void]$List.Add('INTERDOMAIN_TRUST_ACCOUNT')}

  ($UserFlag  -BOR 0x1000)  {[void]$List.Add('WORKSTATION_TRUST_ACCOUNT')}

  ($UserFlag  -BOR 0x2000)  {[void]$List.Add('SERVER_TRUST_ACCOUNT')}

  ($UserFlag  -BOR 0x10000)  {[void]$List.Add('DONT_EXPIRE_PASSWORD')}

  ($UserFlag  -BOR 0x20000)  {[void]$List.Add('MNS_LOGON_ACCOUNT')}

  ($UserFlag  -BOR 0x40000)  {[void]$List.Add('SMARTCARD_REQUIRED')}

  ($UserFlag  -BOR 0x80000)  {[void]$List.Add('TRUSTED_FOR_DELEGATION')}

  ($UserFlag  -BOR 0x100000)  {[void]$List.Add('NOT_DELEGATED')}

  ($UserFlag  -BOR 0x200000)  {[void]$List.Add('USE_DES_KEY_ONLY')}

  ($UserFlag  -BOR 0x400000)  {[void]$List.Add('DONT_REQ_PREAUTH')}

  ($UserFlag  -BOR 0x800000)  {[void]$List.Add('PASSWORD_EXPIRED')}

  ($UserFlag  -BOR 0x1000000)  {[void]$List.Add('TRUSTED_TO_AUTH_FOR_DELEGATION')}

  ($UserFlag  -BOR 0x04000000)  {[void]$List.Add('PARTIAL_SECRETS_ACCOUNT')}

  }

  $List  -join ', '

  }

  #endregion  Helper Functions

  }

  Process  
  {

  ForEach  ($Computer in  $Computername) 
  
  {

  $adsi  = [ADSI]"WinNT://$Computername"

  $adsi.Children | where {$_.SchemaClassName -eq  'user'} |  ForEach {

  [pscustomobject]@{

  UserName = $_.Name[0]

  SID = ConvertTo-SID -BinarySID $_.ObjectSID[0]

  PasswordAge = [math]::Round($_.PasswordAge[0]/86400)

  LastLogin = If ($_.LastLogin[0] -is [datetime]){$_.LastLogin[0]}Else{'Never logged  on'}

  UserFlags = Convert-UserFlag  -UserFlag $_.UserFlags[0]

  MinPasswordLength = $_.MinPasswordLength[0]

  MinPasswordAge = [math]::Round($_.MinPasswordAge[0]/86400)

  MaxPasswordAge = [math]::Round($_.MaxPasswordAge[0]/86400)

  BadPasswordAttempts = $_.BadPasswordAttempts[0]

  MaxBadPasswords = $_.MaxBadPasswordsAllowed[0]

  

  }

  }

  }

  }

} 