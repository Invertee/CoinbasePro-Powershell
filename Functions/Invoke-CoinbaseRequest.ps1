function Invoke-CoinbaseProRequest {
    Param (
        [Parameter()] $Request    
    )

    $EpochStart = Get-Date -Date "01/01/1970"
    $Timestamp = (New-TimeSpan -Start $EpochStart -End (Get-Date).ToUniversalTime()).TotalSeconds
    $Timestamp = ([math]::Round($Timestamp, 0)).ToString()
    $Prehash = $Timestamp + $request.method.ToUpper() + $request.url + $request.body
    $Signature_b64 = Get-HMAC -Message $prehash -Secret $request.secret
    $Header = @{
        "CB-ACCESS-KEY"        = $request.key
        "CB-ACCESS-SIGN"       = $signature_b64
        "CB-ACCESS-TIMESTAMP"  = $Timestamp
        "CB-ACCESS-PASSPHRASE" = $request.passphrase
        "Content-Type"         = 'application/json'
        "accept"               = 'application/json'
    }
    $Uri = $request.endpoint + $request.url
    if ($request.method.ToUpper() -eq 'POST') {
        try { $response = Invoke-RestMethod -Method $request.method -Uri $uri -Headers $header -Body $request.body }
        catch { $Statuscode = $_.exception.message }
    } else {
        try { $response = Invoke-RestMethod -Method $request.method -Uri $uri -Headers $header }
        catch { $Statuscode = $_.exception.message }
    }
        
    if ($Statuscode) {
        $Errorcode = $Statuscode | Select-String -Pattern '\d{3,3}'
        $Errorcode = $Errorcode.Matches.Value
            
        Switch ($Errorcode) {
            '400' { Write-Error "Bad Request. Invalid request format" }
            '401' { Write-Error "Unauthorized. Invalid API Key" }
            '403' { Write-Error "Forbidden. You do not have access to the requested resource" } 
            '404' { Write-Error "Not Found" }
            '500' { Write-Error "Internal Server Error" } 
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

Function Get-BlankAPI {
    Param(
        [Parameter()] [switch] $SandboxAPI   
    )

    $api = @{
        "endpoint"   = 'https://api.pro.coinbase.com'
        "url"        = ''
        "method"     = ''
        "body"       = ''
        "key"        = ''
        "secret"     = ''
        "passphrase" = ''
    }

    if ($SandboxAPI) {
        $api.endpoint = "https://api-public.sandbox.pro.coinbase.com"
    }
    Return $api
}

Function Test-Product {
    Param(
        [Parameter(Position = 0)] [string] $Product   
    )

    $ValidProducts = Import-Csv "$([system.io.path]::GetTempPath())/CoinbaseProPS-Products.csv"

    if ($ValidProducts.id.Contains($Product.ToUpper())) {
        Return $true
    } else {
        Throw "Invalid Product!"
        Return $false
    }
}

Function Test-Currency {
    Param(
        [Parameter(Position = 0)] [string] $Currency   
    )

    $ValidCurrencies = Import-Csv "$([system.io.path]::GetTempPath())/CoinbaseProPS-currencies.csv"

    if ($ValidCurrencies.id.Contains($Currency.ToUpper())) {
        Return $true
    } else {
        Throw "Invalid Currency!"
        Return $false
    }
}