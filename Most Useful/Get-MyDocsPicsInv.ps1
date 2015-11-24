Function Get-ActiveUsers
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		$ComputerName
	)
	PROCESS
	{
		($uid = @(Get-WmiObject -class win32_process -ComputerName $ComputerName -filter "ExecutablePath like '%explorer.exe'" -EA "continue" | Foreach-Object {$_.GetOwner().User}  | Where-Object {$_ -ne "NETWORK SERVICE" -and $_ -ne "LOCAL SERVICE" -and $_ -ne "SYSTEM"} | Sort-Object -Unique))
		If($uid -like "")
		{
			Write-Output "No user"
		}
	}
}
###Above function will be used to determine which profile to use as well as determine whether to proceed with that computername.

Function Get-DocInventory 
{
  	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		$ComputerName
	)
  PROCESS
  {
  #Adapted from http://www.experts-exchange.com/Programming/Languages/Scripting/Powershell/Q_25750847.html
  # Get all configured user profiles (ignore special accounts)
  $user = Get-ActiveUsers $ComputerName
  If($user)
  {
    # Convert the local path to a UNC path
    $UNCPath = "\\$ComputerName\c$\Users\$($user)"
    # Initialise the size values
    $DesktopSize = 0; $MyDocumentsSize = 0
    # Attempt to get the desktop size
    # Check version then get the My Documents size
      If (Test-Path "$UNCPath\My Documents")
      {
        $MyDocumentsSize = (Get-ChildItem "$UNCPath\Documents\" -Recurse | Measure-Object Length -Sum).Sum
      }
      If (Test-Path "$UNCPath\Pictures")
      {
        $PicturesSize = (Get-ChildItem "$UNCPath\Pictures\" -Recurse | Measure-Object Length -Sum).Sum
      }

    # Leave this object in the output pipeline
    $props = @{ComputerName=$ComputerName
               MyDocumentsSize=$MyDocumentsSize
               MyPicturesSize=$PicturesSize
               UserAccount=$user
              }
    $results = New-Object PSObject -Property $props
    $results
  }
  else
  {
    $fails = @{ComputerName=$ComputerName
               User=$User
               }
    $fails | Out-File .\NoUserLoggedIn.csv -Append -NoTypeInformation
  }
  }
}