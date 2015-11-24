###http://pmckibbins.wordpress.com/2013/01/21/powershell-text-to-speech/
# This first section will generate speech from text using a ComObject
#
function Say-Text1 {
    param(
        [Parameter(Mandatory=$true)]
        $Text,
 
        [switch]
        $Slow
    )
 
    $object = New-Object -ComObject SAPI.SpVoice
    if ($Slow) { $object.Rate = -10 }
    $object.Speak($text) | Out-Null
}
 
Say-Text1 "In 1972 a crack commando unit was sent to prison by a military court for a crime they didn't commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune. If you have a problem, if no one else can help, and if you can find them, maybe you can hire the A-Team."
#
#

function Say-Text {
    param ([Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string] $Text)
    [Reflection.Assembly]::LoadWithPartialName('System.Speech') | Out-Null   
    $object = New-Object System.Speech.Synthesis.SpeechSynthesizer 
    $object.Speak($Text) 
}

powershell -noexit -ExecutionPolicy "Bypass" "& ""C:\SystemTools\Say-Text.bat"""

Function Start-Prank ($ComputerName)
{
    Copy-Item "C:\SystemTools\Say-Text.bat" "\\$ComputerName\c$\System Tools\Say-Text.bat"
    Copy-Item "C:\SystemTools\Say-Text.ps1" "\\$ComputerName\c$\System Tools\Say-Text.ps1"
    C:\SystemTools\psexec.exe /acceptEula \\$ComputerName -d -h -s "C:\System Tools\Say-Text.bat"    
}