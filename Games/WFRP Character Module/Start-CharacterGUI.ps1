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
    Start-Process "C:\Modules\end.bat"
	#>
})

$Window.Showdialog() | Out-Null