     Function Combine-akPDFs
     {
	    <#	
		    .SYNOPSIS
			    The Combine-akPDFs function combines the PDFs in the specifed $Source path folder together using iTextSharp.
		
		    .DESCRIPTION
			    The Combine-akPDFs function combines the PDFs in the specifed $Source path folder together using iTextSharp. Bookmarks are added            
                for each file combined together in this way. The folder provided to the Source path is not looked thru Recursively, so only pdf files
                found in the root of the folder will be combined.
		
		    .PARAMETER Source
			    The path to the PDF files to combine together.
		
		    .PARAMETER Target
			    The path that the combined PDF file should be output into, as well as the XML file used for creating the bookmarks.

		    .PARAMETER DLL
			    The path to the iTextSharp DLL file.

		    .PARAMETER FileName
			    The Name of the combined pdf file. Defaults to Combined.pdf   

		    .EXAMPLE
			    Combine-akPDFs -Source C:\Scripts\PDFCombining\ -Target C:\Scripts\PDFCombining\ -Verbose
			
			    Will find all the PDF files in the root of the folder PDFCombining and output a combined pdf into a Combined folder under PDFCombining.
			
	    #>
	    [CmdletBinding()]
	    param
	    (
		    [Parameter(Mandatory=$True,
		    ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		    [string]$Source,
            [Parameter(Mandatory=$True,
		    ValueFromPipelinebyPropertyName=$true)]
		    [string]$Target,
		    [Parameter(Mandatory=$False,
		    ValueFromPipelinebyPropertyName=$true)]
		    [string]$DLL = "C:\Users\ldpcmai\Downloads\WFRP_PC_GeneratorV1\itextsharp.dll",
		    [Parameter(Mandatory=$False,
		    ValueFromPipelinebyPropertyName=$true)]
		    [string]$FileName = "Combined.pdf"
	    )
        Begin
        {
            Try
            {
                Add-Type -Path $DLL -ErrorAction Stop
            }
            Catch
            {
                Throw "Could not load iTextSharp DLL from $($DLL).`nPlease check that the dll is located at that path."
            }
            If(!(Test-Path "$Target\Combined"))
            {
                New-Item -Path $Target -Name Combined -ItemType Directory
            }
        }
        Process
        {
     
            #bookmark
            $PageOffset = 0
            $n = 0
            $XmlString = @"
    <?xml version="1.0" encoding="ISO8859-1"?>
    <Bookmark>
    "@
            $FinalXML = @()
            $FinalXML += $XmlString
            #end bookmark
      
            $EndFile = [System.IO.Path]::Combine("$($Target)\Combined", $FileName)
            $FileStream = New-Object System.IO.FileStream($EndFile, [System.IO.FileMode]::OpenOrCreate)        
            $Document = New-Object iTextSharp.text.Document
            $PdfCopy = New-Object iTextSharp.text.pdf.PdfCopy($Document, $FileStream)
            $Document.Open()
            $i = 0
            $pdfs = Get-ChildItem -Path $Source -Filter "*.pdf"
            ForEach($pdf in $pdfs)
            {
                $PdfReader = New-Object iTextSharp.text.pdf.PdfReader($pdf.FullName)            
                #BookMark adding code
                $n = $PdfReader.NumberOfPages           
                If($i -eq 0)
                {
                    $PageOffset += $n + 1
                    $BookMarkXml = @"
        <Title Open="false" Page="1  XYZ 69 720 0" Action="GoTo" >$($Pdf.Name)</Title>
"@        
                    $FinalXML += $BookMarkXml
                }
                else
                {
                    $PageOffset = $PageOffset
                    $BookMarkXml = @"
        <Title Open="false" Page="$($PageOffSet)  XYZ 69 720 0" Action="GoTo" >$($Pdf.Name)</Title>
"@
                    $PageOffset += $n
                    $FinalXML += $BookMarkXml
                }
                $i++
                Write-Verbose $PageOffset
                $PdfCopy.AddDocument($PdfReader)
                $PdfReader.Dispose()       
            }
            $FinalXML += '</Bookmark>'
            $FinalXML | Out-File $Target\Combined\FileBookmarks.xml
            $FinalXMLFile = New-Object System.IO.StreamReader -ArgumentList "$($Target)\Combined\FileBookmarks.xml"
            $FinalBookMarks = [iTextSharp.text.pdf.SimpleBookmark]::ImportFromXML($FinalXMLFile)
            $PdfCopy.Outlines = $FinalBookMarks
            $PdfCopy.Dispose()
            $Document.Dispose()
            $FinalXmlFile.Close()
            Remove-Item -Path "$($Target)\Combined\FileBookmarks.xml"
        }
        End{}
    }