#Setup script for files to compare#
$path = "C:\Scripts\Event4\"
1..2 | % {
	Set-Location -Path (md -path "$path\$_").FullName
1..20 | % {New-Item -Name "$_.txt" -ItemType File}
Remove-Item -Path ("{0}.txt" -F (Get-Random -Minimum 1 -Maximum 20))
}
Pop-Location
#End Setup script
$folder1 = Get-ChildItem -Path "C:\Scripts\Event4\1"
$folder2 = Get-ChildItem -Path "C:\Scripts\Event4\2"
Compare-Object -ReferenceObject $folder1 -DifferenceObject $folder2 -Property Name -PassThru | Select Name, LastWriteTime, Mode, Length, FullName
#Above I believe satisfies this event, although I think I used I different method than intended. Additionally, if no files were different, noting would be returned.