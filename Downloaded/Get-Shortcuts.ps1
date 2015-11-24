# List all .lnk files and their image paths
$IPAddress = "IP address to filter on"
Function Get-Shortcuts
{
#$Path = "Directory_to_Search"
$Path = "C:\users\ldpcmai\"
$Items = Get-ChildItem $Path -Recurse -Include *.lnk 
ForEach ($Item in $Items) {
   $Shell = New-Object -ComObject WScript.Shell 
   $Properties = @{
        ShortcutName = $Item.Name
        ShortcutPath = $Item.FullName  
        Target = $Shell.CreateShortcut($Item).targetpath 
            }
New-Object PSObject -Property $Properties 
} 
[Runtime.InteropServices.Marshal]::ReleaseComObject($Shell) | Out-Null
}

Get-Shortcuts | Where {$_.Target -like "*$IPAddress*"}

###Adapted from http://www.computerperformance.co.uk/powershell/powershell_create_shortcut.htm