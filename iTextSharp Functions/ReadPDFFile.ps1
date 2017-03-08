    function ReadPdfFile{
            param(
                [string]$fileName
            )
            If(!(Test-Path .\itextsharp.dll))
            {
                throw "Change into directory contain itextsharp.dll before running this function."
            }
            Add-Type -Path .\itextsharp.dll
            #$text= New-Object -TypeName System.Text.StringBuilder
            if(Test-Path $fileName){
                $pdfReader = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $fileName
                    ForEach($page in (1..$pdfReader.NumberOfPages))
                    {
                        #$strategy = [iTextSharp.text.pdf.parser.SimpleTextExtractionStrategy]
                        #$PdfTextExtractor = [iTextSharp.text.pdf.parser.PdfTextExtractor]
                        $currentText=[iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($pdfReader,$page,[iTextSharp.text.pdf.parser.SimpleTextExtractionStrategy]::new())
                        $UTF8 = New-Object System.Text.UTF8Encoding 
                        $ASCII = New-Object System.Text.ASCIIEncoding
                        $EndText = $UTF8.GetString($ASCII::Convert([System.Text.Encoding]::Default, [System.Text.Encoding]::UTF8, [System.Text.Encoding]::DEFAULT.GetBytes($currentText)))
                        $EndText
                        #$currentText
                        } #end for loop
            $pdfReader.Close()
                }
        }

    #ReadPdfFile -fileName .\test.pdf    