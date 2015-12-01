#These need to be added to the current powershell profile.
#Create aliases for commonly opened programs.
Set-Alias -name np -value $env:WinDir\notepad.exe
Set-Alias wd "C:\Program Files (x86)\Microsoft Office\Office15\winword.exe"
Set-Alias xl "C:\Program Files (x86)\Microsoft Office\Office15\Excel.exe"
Set-Alias ie "C:\Program Files (x86)\Internet Explorer\iexplore.exe"
Set-Alias web "C:\Users\ldpcmai\AppData\Local\Google\Chrome\Application\chrome.exe"
Set-Alias ld "C:\Program Files (x86)\LANDesk\ManagementSuite\Console.exe"
Set-Alias ad "C:\Users\ldpcmai\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Active Directory Users and Computers.lnk"
Set-Alias ol "C:\Program Files (x86)\\Microsoft Office\Office15\OUTLOOK.EXE"
#Create aliases for commonly used Cmdlets
Set-Alias grok Get-Help
#Create function to start commonly used programs
Function sd {web;ad;ol;ld}
