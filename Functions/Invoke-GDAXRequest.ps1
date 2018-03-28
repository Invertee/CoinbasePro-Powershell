function Invoke-Request {

    Param (
    [Parameter()] $Request    
    )

    $EpochStart = Get-Date -Date "01/01/1970"
    $Now = Get-Date
    $Timestamp = (New-TimeSpan -Start $EpochStart -End $Now.ToUniversalTime()).TotalSeconds
    $Timestamp = ([math]::Round($Timestamp, 3)).ToString()
    $Prehash = $Timestamp + $request.method.ToUpper() + $request.url + $request.body
    $Signature_b64 = Get-HMAC -Message $prehash -Secret $request.secret
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
        catch {$Statuscode = $_.exception.message}
    } else {
        try {$response = Invoke-RestMethod -Method $request.method -Uri $uri -Headers $header}
        catch {$Statuscode = $_.exception.message}
    }
        
    if ($Statuscode) {
            $Errorcode = $Statuscode | Select-String -Pattern '\d{3,3}'
            $Errorcode = $Errorcode.Matches.Value
            
        Switch ($Errorcode) {
            '400' {Write-Error "Bad Request. Invalid request format"}
            '401' {Write-Error "Unauthorized. Invalid API Key"}
            '403' {Write-Error "Forbidden. You do not have access to the requested resource"} 
            '404' {Write-Error "Not Found"}
            '500' {Write-Error "Internal Server Error"} 
            }
            
        }
        Return $response
        }

function Get-HMAC {
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