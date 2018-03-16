function Invoke-Request {

    Param (
    [Parameter()] $Request    
    )

    $EpochStart = Get-Date -Date "01/01/1970"
    $Now = Get-Date
    $Timestamp = (New-TimeSpan -Start $EpochStart -End $Now.ToUniversalTime()).TotalSeconds
    $Timestamp = ([math]::Round($Timestamp, 3)).ToString()
    $Prehash = $Timestamp + $request.method.ToUpper() + $request.url + $request.body
    $Signature_b64 = Calculate-HMAC -Message $prehash -Secret $request.secret
    $Header = @{
        "CB-ACCESS-KEY" = $request.key
        "CB-ACCESS-SIGN" = $signature_b64
        "CB-ACCESS-TIMESTAMP" = $Timestamp
        "CB-ACCESS-PASSPHRASE" = $request.passphrase
        "Content-Type" = 'application/json'
    }
    $Uri = $request.endpoint + $request.url
    if ($request.method.ToUpper() -eq 'POST') {
        try {$response = Invoke-RestMethod -Method $request.method -Uri $uri -Headers $header -Body $request.body}
        catch {$Statuscode = $_.Exception.response.Statuscode}
    } else {
        try {$response = Invoke-RestMethod -Method $request.method -Uri $uri -Headers $header}
        catch {$Statuscode = $_.Exception.response.Statuscode}
    }

    <#
    if ($Statuscode) {
    if ($Statuscode -eq 400) {Write-Error -Message "Bad Request – Invalid request format"}    
    if ($Statuscode -eq 401) {Write-Error -Message "Unauthorized – Invalid API Key"}  
    if ($Statuscode -eq 403) {Write-Error -Message "Forbidden – You do not have access to the requested resource"}  
    if ($Statuscode -eq 403) {Write-Error -Message "Not Found"}  
    if ($Statuscode -eq 500) {Write-Error -Message "Internal Server Error"} 
    } else {
    return $response 
    #>
    $response  
    }

function Calculate-HMAC {
    Param(
    [Parameter()] $Message,
    [Parameter()] $Secret    
    )

    $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
    $hmacsha.key = [Convert]::FromBase64String($secret)
    $signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($message))
    $signature = [Convert]::ToBase64String($signature)
    return $signature
}