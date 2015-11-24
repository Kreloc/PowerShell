Function ConvertTo-CodeFormat
{
	param
	(
		[string]$path
	)
	$code = Get-Content $path
	$count = $code.count
	$i = 0
	Do
	{
		$code[$i] = "    " + $code[$i]
		$i++
	}
	until($i -gt ($count -1))
	$code
}
<#
Usage

   ConverTo-CodeFormat .\Get-BiosInfo.ps1 | Clip
   #Pastes the converted data to the clipboard to be posted in online forum such as Reddit or Stack-Exchange
   #>