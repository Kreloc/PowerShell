$SourceURl = http://www.reddit.com/r/PowerShell/comments/347fuw/network_share_management_script/

#Function Convert-ToFriendlyName 
#Accepts a string
#Removes specifically defined characters from string and sets to all lowercase
#Returns new string
Function Convert-ToFriendlyName{
param ($Text)
# Unwanted characters converted to a regex:
$SpecChars = '!', '"', '£', '$', '%', '&', '^', '*', '(', ')', '@', '=', '+', '¬', '`', '<', '>', '?', '/', ';', '#', '~', "'"
$remspecchars = [string]::join('|', ($SpecChars | % {[regex]::escape($_)}))
# Convert the text given to correct naming format (Uppercase)      
$name = (Get-Culture).textinfo.totitlecase(“$Text”.tolower())
# Remove unwanted characters
$name = $name -replace $remspecchars, ""
$name
}

$DaysToKeep = (Get-Date).AddDays(-30)
$location = "Z:\"

Get-ChildItem -Path $location -Recurse  | Where-Object {$_.PSIsContainer } | ForEach-Object {
    #Define directory name and destination file name
    $directoryFullName = $_.FullName
    $directoryName = $_.Name
    $destFile = Convert-ToFriendlyName "$directoryFullName\$directoryName"+".7z"

    #Loop through each directory, zip up any files tha have a LastWriteTime less than $daysToKeep
    If(!(Test-Path -Path $destFile))
    {
    Get-ChildItem –Path  $directoryFullName –Recurse | Where-Object{$_.LastWriteTime –lt $DaysToKeep -and $_.Extension -ne ".7z"} | ForEach-Object {
        $fileToZip = $directoryFullName + "\" + $_
        Invoke-Expression -Command "C:\apps\7-Zip\7z.exe a '$destFile' '$fileToZip'" 
        Remove-item -Recurse $fileToZip 
    }
}
#Wants it to not zip files that already have a zip file.
#Only needs the first level directory, as 7zip will zip the rest below it.
$destFile = "C:\Scripts\tester.7z"
$fileToZip = "C:\Scripts\Test"
If(!(Test-Path -Path $destfile))
{
Invoke-Expression -Command "C:\Scripts\7zip\7z.exe a '$destFile' '$fileToZip'"
} 