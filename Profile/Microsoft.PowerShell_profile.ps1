Set-Location C:\Scripts
Import-Module Toolkit
Import-Module PsLANDesk
Import-Module PsNetDevices
Import-Module Posh-SSH
Import-Module PSAdobe
Import-Module PsLANDesk
Import-Module PSScriptAnalyzer
Function Get-DateString {(Get-Date).ToString("MMddHHmmmm")}
$filedate = Get-DateString
$eod = Get-Excuse
#Set Custom Aliases
#Create aliases for commonly opened programs.
Set-Alias -name np -value $env:WinDir\notepad.exe
Set-Alias wd "C:\Program Files (x86)\Microsoft Office\Office15\winword.exe"
Set-Alias xl "C:\Program Files (x86)\Microsoft Office\Office15\Excel.exe"
Set-Alias ie "C:\Program Files (x86)\Internet Explorer\iexplore.exe"
Set-Alias web "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
Set-Alias ld "C:\Program Files\LANDesk\ManagementSuite\Console.exe"
Set-Alias ad "C:\Users\ldpcmai\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Active Directory Users and Computers.lnk"
Set-Alias ol "C:\Program Files (x86)\\Microsoft Office\Office15\OUTLOOK.EXE"
#Create function for -full help.
Function grok{param($Command)Get-Help $Command -Full}
#Create function to start commonly used programs
Function sd {web;ad;ol;ld}
#End Custom Aliases
Write-Output "Good morning! It is $(Get-Date) and the excuse of the day is `n
$($eod) `n
Don't forget to run sd function if computer has just started."
Start-Transcript -Path "C:\Scripts\PSLogs\$($filedate).txt"