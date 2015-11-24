<#Another one that is now broekn cause the API is gone now.
Function Get-ProductRecalls
{
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)][Alias('Product')]$query				
	)	
    begin{$webclient = New-Object System.Net.webclient}
    process
    {
		$url = "http://api.usa.gov/recalls/search.json?query=$query"
		$jsonData = $webclient.downloadstring($url)
		$recalls = ConvertFrom-Json $jsonData
		$total = $recalls.success.total
		$results = $recalls.success.results
		ForEach($result in $results)
		{
			$props = [ordered]@{Organization=$result.organization
						RecallNumber=$result.Recall_number
						RecallDate=$result.Recall_date
						RecallUrl=$result.Recall_url	
			}			
			If($result.Product_Types)
			{
				$props["Manufacturers"]=$result.manufacturers
				$props["ProductTypes"]=$result.Product_types
				$props["Hazards"]=$result.Hazards
				$props["Countries"]=$result.countries																
			}
			if($result.defect_summary)
			{
				$props["Records"]=$result.records
				$props["ComponentDescription"]=$result.Component_description
				$props["Manufacturer"]=$result.manufacturer
				$props["DefectSummary"]=$result.defect_summary
				$props["Summary"]=$result.consequence_summary
				$props["CorrectiveAction"]=$result.corrective_summary
				$props["Notes"]=$result.notes
				$props["Subject"]=$result.recall_subject													
			}
			if($result.description)
			{
				$props["Description"]=$result.description
				$props["Summary"]=$result.summary								
			}
          $outputData = New-Object -TypeName PSObject -Property $props
		  $outPutData			
		}
						
		}
			end{}
	}
					


#Hazards is food
#Components is Auto
#Product_Types is Consumer Product.
#>