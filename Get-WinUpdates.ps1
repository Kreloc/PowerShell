function Get-Updates
{
    $Session = New-Object -ComObject "Microsoft.Update.Session"
    $Searcher = $Session.CreateUpdateSearcher()
    $historyCount = $Searcher.GetTotalHistoryCount()
    $Searcher.QueryHistory(0, $historyCount) | Select-Object Date,
    @{name="Operation"; expression={switch($_.operation){
    1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}}}},
    @{name="Status"; expression={switch($_.resultcode){
	1 {"In Progress"}; 2 {"Succeeded"}; 3 {"Succeeded With Errors"};
	4 {"Failed"}; 5 {"Aborted"}
	}}}, Title,@{name="KB"; expression={(($_.title -split ".*\(") -replace "\)*","")[1]}}
}

function Get-Updates
{
	[CmdletBinding()]
    Param (
        [Parameter(position=0,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)][String] 
        $ComputerName = $env:ComputerName
	)
	PROCESS
	{
	[System.Reflection.Assembly]::LoadWithPartialName(‘Microsoft.Update.Session‘) | Out-Null
    $Session = [activator]::CreateInstance([type]::GetTypeFromProgID(“Microsoft.Update.Session“,$ComputerName))
    $Searcher = $Session.CreateUpdateSearcher()
    $historyCount = $Searcher.GetTotalHistoryCount()
    $Searcher.QueryHistory(0, $historyCount) | Select-Object Date,
    @{name="Operation"; expression={switch($_.operation){
    1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}}}},
    @{name="Status"; expression={switch($_.resultcode){
	1 {"In Progress"}; 2 {"Succeeded"}; 3 {"Succeeded With Errors"};
	4 {"Failed"}; 5 {"Aborted"}
	}}}, Title,@{name="KB"; expression={(($_.title -split ".*\(") -replace "\)*","")[1]}},@{name="PC";expression={$ComputerName}}
	}
}
Get-Updates

List of computers | ForEach-Object {Get-Updates $_}

##(($result[0].Title -split ".*\(") -replace "\)*","")[1]
##work snippet to make above regex.

Above is taken from comment on Scripting Guy article [here](http://blogs.technet.com/b/heyscriptingguy/archive/2009/03/09/how-can-i-list-all-updates-that-have-been-added-to-a-computer.aspx) by Stu. This worked on my machine for all the updates installed.
	
}
function Get-WinUpdates
{
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipeline=$True)]
		[string]$ComputerName	
	)
	PROCESS
	{
		$Date = Get-Date
		$test = test-connection -ComputerName $ComputerName -Count 1 -Quiet
		If ($test -eq $false)
		{
			Write-Output "$ComputerName could not be contacted on $Date"
		}
		else
		{
			$result = Get-WinEvent -FilterHashTable @{ProviderName="Microsoft-Windows-WindowsUpdateClient"; ID=19} -ComputerName $ComputerName | foreach {$_.properties[0]}
			Write-Output "$ComputerName has these updates installed"
			$result	
		}
	}	
}
###ID Values for Microsoft-Windows-User Profiles Service.
###ID=4 is 'Finished processing user logoff notification on session 1.' ID=3 is 'Recieved user logoff notification on session 1.' ID=2 is 'Finished processing user logon notification on session 1.'
####Notes on user function. Will display last log off time from this Windows Event Log.
$winevent = Get-Winevent -FilterHashTable @{ProviderName="Microsoft-Windows-User Profiles Service"} -ComputerName $ComputerName
$user = $winevent | Where-Object {$_.ID -eq 5 -and $_.Message -Match "^Registry file C:\\Users\\l"}
$user = (($user[0].Message.Substring(23)) -Split "\\")[0]
#Above line gets just the username of the last logged in profile that begins with the letter l. My environment all user accounts for people begin with this letter.
$logofftime = ($winevent | Where {$_.ID -eq 4} | foreach {$_.TimeCreated})[0]
$logontime = ($winevent | Where {$_.ID -eq 2} | foreach {$_.TimeCreated})[0]
##Use New-TimeSpan to determine if still loggged on. If value of any is positive, someone is logged on.
New-TimeSpan $logofftime $logontime
$diff = (New-TimeSpan $logofftime $logontime).TotalMilliseconds
If ($diff -gt 0)
{
	Write-Output "$user is currently logged onto the machine"
}
else
{
	Write-Output "$user is logged off and the computer is running."
}
### Old version. Doesn't always have the correct user account in this string.
# $user = (Get-Winevent -FilterHashTable @{ProviderName="Microsoft-Windows-User Profiles Service"; ID=5} -ComputerName $ComputerName | foreach {$_.Message})[0]
###Gets message about registry keys loaded for profile.
###Combo above two to create script that gets the username of currently logged on user.

function Get-ActiveUser
{
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipeline=$True)]
		[string]$ComputerName	
	)
	PROCESS
	{
		$Date = Get-Date
		$test = test-connection -ComputerName $ComputerName -Count 1 -Quiet
		If ($test -eq $false)
		{
			Write-Output "$ComputerName could not be contacted on $Date"
		}
		else
		{
			$winevent = Get-Winevent -FilterHashTable @{ProviderName="Microsoft-Windows-User Profiles Service"} -ComputerName $ComputerName
			$user = $winevent | Where-Object {$_.ID -eq 5 -and $_.Message -Match "^Registry file C:\\Users\\l"}
			$user = (($user[0].Message.Substring(23)) -Split "\\")[0]
			$logofftime = ($winevent | Where {$_.ID -eq 4} | foreach {$_.TimeCreated})[0]
			$logontime = ($winevent | Where {$_.ID -eq 2} | foreach {$_.TimeCreated})[0]
			$diff = (New-TimeSpan $logofftime $logontime).TotalMilliseconds
			If ($diff -gt 0)
			{
				Write-Output "$user is currently logged onto $ComputerName as of $Date"
			}
			else
			{
				Write-Output "$user is logged off and $ComputerName is running."
			}
			$user
		}
	}
}