Function Find-EmptyCSV ($path)
{
	Begin
	{
		$csv = Import-CSV $path
	}
	Process
	{
		$count = 1
		$csv | ForEach-Object {
			ForEach ($property in $_.PSObject.Properties)
			{
				if(!$property.Value.Trim())
				{
					$props = @{Property="$($property.Name)"
								RowNumber=$count
								}
					$obj = New-Object PSObject -Property $props
					[array]$empty += $obj
				}
		}
			$count++
}
		}
		End
		{
			If($empty)
			{
				ForEach($row in $empty)
				{
					$num = ($row.RowNumber -1)
					$prop = $row.Property
					#This is the spot for Ifs and a set of constants that properties should contain
					<#
					If ($row.property -like "*Company*")
					{
						$csv[$num].$prop = "CompanyValue"
					} 
					#>
					$csv[$num].$prop = "NA"
				}
				$csv
			}
		}
}