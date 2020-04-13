$outputFolder = "output-folder-path-goes-here"

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
# Add headers
#$headers.Add("Content-Type", 'application/json')
#$headers.Add("Authorization", 'someBasicAuthValue')

add-type @"
   using System.Net;
   using System.Security.Cryptography.X509Certificates;
   public class TrustAllCertsPolicy : ICertificatePolicy {
       public bool CheckValidationResult(
           ServicePoint srvPoint, X509Certificate certificate,
           WebRequest request, int certificateProblem) {
           return true;
       }
   }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

# Add content to request body
#$body = @{onFeatureOpen='true'}
$json = $body | ConvertTo-Json
$response = Invoke-RestMethod 'url-goes-here' -Method Post -Header $headers -Body $json -ContentType 'application/json'
$response | ConvertTo-Json -Depth 999 | Out-File $outputFolder + 'output-file-name-goes-here.json'