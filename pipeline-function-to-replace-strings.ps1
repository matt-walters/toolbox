$outputFolder = "output-folder-path-goes-here"

# Pipeline function to replace strings
function ReplaceStrings
{
    param([Parameter(Mandatory = $true, ValueFromPipeline=$true)][string]$text)
    
    $text = $text -replace 'some-string', 'some-other-string'

    $text
}

# Example usage
# $response | ConvertTo-Json -Depth 999 | ReplaceStrings | Out-File $outputFolder + 'output-file-name-goes-here.json'