#Build the GUI
#.Links http://learn-powershell.net/category/wpf/
Powershell -sta
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
#Above needs to be loaded for this to work.
Import-Module WFRP
[xml]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" Title="Create your character" WindowStartupLocation = "CenterScreen"
    SizeToContent = "WidthAndHeight" ShowInTaskbar = "True" Background = "lightgray"> 
    <StackPanel x:Name='StackPanel'>
        <Label Content='Enter the name of your character' />
        <TextBox x:Name="NameBox" Height = "50" />
        <Label Content='Choose your race' />		  
        <RadioButton x:Name="Human" Content = 'Human (Race)' GroupName='Race'/>
        <RadioButton x:Name="Dwarf" Content = 'Dwarf (Race)' GroupName='Race'/>
        <RadioButton x:Name="Elf" Content = 'Elf (Race)' GroupName='Race'/>
		<RadioButton x:Name="Halfling" Content = 'Halfling (Race)' GroupName='Race'/> 
        <Separator/>
		<TextBox x:Name='Race'/>
        <Label Content='Is your character young or old?' />
        <RadioButton x:Name="Young" Content = 'Young' GroupName='Agechoice'/>
        <RadioButton x:Name="Old" Content = 'Old' GroupName='Agechoice'/>
		<TextBox x:Name='AgeC'/>
        <Label Content='Is your character male or female?' />
        <RadioButton x:Name="Male" Content = 'Male' GroupName='Gender'/>
        <RadioButton x:Name="Female" Content = 'Female' GroupName='Gender'/>
		<TextBox x:Name='GenderC'/>					
		<TextBox x:Name='NameC'/>						 
		<Button x:Name = "Button" Content = 'Create Character' Height = "75" Width = "100" ToolTip = "This is a button"/>			
    </StackPanel>
</Window>
"@
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )

$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach {
    Set-Variable -Name ($_.Name) -Value $Window.FindName($_.Name)
}

$button.Add_Click({
	$radiochoices = $($StackPanel.Children | Where {
    $_ -is [system.windows.controls.radiobutton] -and $_.IsChecked} | Select -ExpandProperty Name)
	$name = $NameBox.text
	$NameC.Text = $name
	$Race.Text = $radiochoices | Where {$_ -like "Human" -or $_ -like "Elf" -or $_ -like "Dwarf" -or $_ -like "Halfling"}
	$AgeC.Text = $radiochoices | Where {$_ -like "Young" -or $_ -like "Old"}
	$GenderC.Text = $radiochoices | Where {$_ -like "Male" -or $_ -like "Female"}
	Get-Stats -Name $name -Race $($Race.Text) -OldYoung $($AgeC.Text) -Gender $($GenderC.Text)
    $pc | Export-CSV $pwd\temppc.csv -NoTypeInformation -Force
	$Window.close()
    .\FinishCharacterGUI.ps1
	#>
})

$Window.Showdialog() | Out-Null

####
powershell -sta
Import-Module WFRP
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
$PC = Import-CSV $pwd\temppc.csv
[xml]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" Title="Create your character" WindowStartupLocation = "CenterScreen"
    SizeToContent = "WidthAndHeight" ShowInTaskbar = "True" Background = "lightgray"> 
    <StackPanel x:Name='StackPanel'>
        <Label Content='Charactereristics so far.' />
		<TextBox x:Name='M'/>        
        <Label Content='Choose your career class' />		  
        <RadioButton x:Name="Warrior" Content = 'Warrior' GroupName='CareerClass'/>
        <RadioButton x:Name="Ranger" Content = 'Ranger' GroupName='CareerClass'/>
        <RadioButton x:Name="Rogue" Content = 'Rogue' GroupName='CareerClass'/>
		<RadioButton x:Name="Academic" Content = 'Academic' GroupName='CareerClass'/>
		<Button x:Name = "Button" Content = 'Finish Creating Character' Height = "75" Width = "150" ToolTip = "This is a button"/>	         
        <Separator/>	
	</StackPanel>
</Window>
"@

$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )

$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach {
    Set-Variable -Name ($_.Name) -Value $Window.FindName($_.Name)
}
$Window.Add_Loaded({
    	$M.Text = "M: $($PC.M) WS: $($PC.WS) BS: $($PC.BS) S: $($PC.S) T: $($PC.T) W: $($PC.W) I: $($PC.I) A: $($PC.A) Dex: $($PC.Dex) Ld: $($PC.Ld) Int: $($PC.Int) Cl: $($PC.Cl) WP: $($PC.WP) Fel: $($PC.Fel)"
})
    If($($PC.WS) -lt 30)
    {
        $Warrior.Visibility = "Hidden"
    }
    If($($PC.Int) -lt 30 -or $($PC.WP) -lt 30)
    {
        $Academic.Visibility = "Hidden"
    }
	If ($($PC.BS) -lt 30)
	{
		$Ranger.Visibility = "Hidden"
	}
	If ($($PC.I) -lt 30)
	{
		$Rogue.Visibility = "Hidden"
        If($($PC.Race) -eq "Elf" -and ($($PC.I)) -lt 65)
        {
		  $Rogue.Visibility = "Hidden"            
        }
	}  

$button.Add_Click({
	$radiochoices = $($StackPanel.Children | Where {
    $_ -is [system.windows.controls.radiobutton] -and $_.IsChecked} | Select -ExpandProperty Name)
    $CareerClass = $radiochoices | Where {$_ -like "Warrior" -or $_ -like "Ranger" -or $_ -like "Academic" -or $_ -like "Rogue"}
    $PC | Add-Member -MemberType NoteProperty -Name CareerClass -Value $CareerClass
    $BaseTrappings = Get-BaseTrappings $CareerClass
    $Skills = Get-InitialSkills $($PC.Race) $($PC.Age) $($PC.CareerClass)
    $SkillList = ($Skills.Skills) -join ', '
    $BasicCareer = Get-Career $($PC.Race) $($PC.CareerClass)
    $BaseCareer = $($BasicCareer.BasicCareer)
    #$BaseCareerAdditions = Get-BasicCareerAdditions $BaseCareer
    $FinTrappings = $($BaseTrappings.Trappings) + $($BaseCareerAdditions.Trappings)
    $FinSkills = $SkillList # + $BaseCareerAdditions.Skills
    $PC | Add-Member -MemberType NoteProperty -Name Skills -Value $FinSkills #Ignore Re-Roll and if a skill duplicates again, manually re-roll that skill.
    $PC | Add-Member -MemberType NoteProperty -Name BasicCareer -Value $BaseCareer
    $PC | Add-Member -MemberType NoteProperty -Name Trappings -Value $FinTrappings
    $PC | Add-Member -MemberType NoteProperty -Name 'Hand To Hand Weapons' -Value $($BaseTrappings.MeleeWeapons)
    $PC | Add-Member -MemberType NoteProperty -Name Wealth -Value $($BaseTrappings.Wealth)        
    $pc | Export-CSV $pwd\temppc.csv -NoTypeInformation -Force
$Document = "C:\Modules\WFRP\WFRPSheet.pdf"
$Output = "C:\Modules\WFRP\$($PC.Name)Sheet.pdf"
Add-Type -Path "C:\Modules\WFRP\itextsharp.dll"
$reader = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $Document
$stamper = New-Object iTextSharp.text.pdf.PdfStamper($reader,[System.IO.File]::Create($Output))
$pdfFields=@{
'Name' = $PC.Name
'Race' = $PC.Race
'Gender' = $PC.Gender
'CareerClass' = $PC.CareerClass
'Align' = $PC.Alignment
'Age' = $PC.Age
'Height' = $PC.HeightInInches
'Current Career' = $PC.BasicCareer
'M' = $PC.M
'WS' = $PC.WS
'BS' = $PC.BS
'S' = $PC.S
'T' = $PC.T
'W' = $PC.W
'I' = $PC.I
'A' = $PC.A
'Dex' = $PC.Dex
'Ld' = $PC.Ld
'Int' = $PC.Int
'Cl' = $PC.Cl
'WP' = $PC.Wp
'Fel' = $PC.Fel
'Skills' = $PC.Skills
'H2H_Weaps' = $PC.'Hand To Hand Weapons'
'FP' = $PC.FatePoints
'Psych' = $PC.Psychology
'Trapps' = $PC.Trappings
'Wealth' = $PC.Wealth
}
ForEach ($field in $pdfFields.GetEnumerator())
{
	$stamper.AcroFields.SetField($field.Key, $field.Value) | Out-Null 
}
$stamper.close()    
	$Window.close()
})        
$Window.Showdialog() | Out-Null
