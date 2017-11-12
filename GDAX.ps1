    # Variables
    $sec = Import-Csv $psscriptroot\GDAX-Det.csv
    $GDAXKey = $sec.key
    $GDAXSecret = $sec.secret
    $GDAXPhrase = $sec.phrase

    $api = @{
        "endpoint" = 'https://api.gdax.com'
        "url" = '/accounts'
        "method" = 'GET'
        "body" = ''
        "key" = $GDAXKey
        "secret" = $GDAXSecret
        "passphrase" = $GDAXPhrase
    }


    function HMAC($message, $secret) {
        $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
        $hmacsha.key = [Convert]::FromBase64String($secret)
        $signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($message))
        $signature = [Convert]::ToBase64String($signature)
        return $signature
    }


    function Invoke-Request($request) {
        $unixEpochStart = Get-Date -Date "01/01/1970"
        $now = Get-Date
        $timestamp = (New-TimeSpan -Start $unixEpochStart -End $now.ToUniversalTime()).TotalSeconds
        # round timestamp to 3 decimal places and convert to string
        $timestamp = ([math]::Round($timestamp, 3)).ToString()
        # create the prehash string by concatenating required parts
        $prehash = $timestamp + $request.method.ToUpper() + $request.url + $request.body
        $signature_b64 = HMAC -message $prehash -secret $request.secret
        $header = @{
            "CB-ACCESS-KEY" = $request.key
            "CB-ACCESS-SIGN" = $signature_b64
            "CB-ACCESS-TIMESTAMP" = $timestamp
            "CB-ACCESS-PASSPHRASE" = $request.passphrase
            "Content-Type" = 'application/json'
        }
        $uri = $request.endpoint + $request.url
        if ($request.method.ToUpper() -eq 'POST') {
            $response = Invoke-RestMethod -Method $request.method -Uri $uri -Headers $header -Body $request.body
        } else {
            $response = Invoke-RestMethod -Method $request.method -Uri $uri -Headers $header
        }
        return $response

    }

    # Get requests.
    function Get-CoinbaseAccounts {     
        $api.method = 'GET'
        $api.url = "/coinbase-accounts"
        $response = Invoke-Request $api
        Write-Output $response
    }

    function Get-GDAXAccount { 
            
            Param([parameter(Mandatory=$false)]$AccountID)

            If ($AccountID -eq $null) {
            $api.method = 'GET'
            $api.url = '/accounts'
            $response = Invoke-Request $api
            Write-Output $response
    } ELSE {
            $api.method = 'GET'
            $api.url = "/accounts/$AccountID"
            $response = Invoke-Request $api
            Write-Output $response
            }
        
    }
    
    function Get-GDAXAccountHistory { 
        <#
        TODO: Impliment pagination - https://docs.gdax.com/#pagination
        Only gets last 100 results.
        #>
                Param([parameter(Mandatory=$true)]$AccountID)
        
                $api.method = 'GET'
                $api.url = "/accounts/$AccountID/ledger"
                $response = Invoke-Request $api
                Write-Output $response
    }

    function Get-GDAXAccountHolds { 
        <#
        TODO: Impliment pagination - https://docs.gdax.com/#pagination
        Only gets last 100 results.
        #>
                Param([parameter(Mandatory=$true)]$AccountID)
        
                $api.method = 'GET'
                $api.url = "/accounts/$AccountID/holds"
                $response = Invoke-Request $api
                Write-Output $response
    }

    function Get-GDAXProducts {     
                $api.method = 'GET'
                $api.url = "/products"
                $response = Invoke-Request $api
                Write-Output $response
    }

    function Get-GDAXCurrencies {     
        $api.method = 'GET'
        $api.url = "/currencies"
        $response = Invoke-Request $api
        Write-Output $response
    }

    function Get-GDAXTime {     
        $api.method = 'GET'
        $api.url = "/time"
        $response = Invoke-Request $api
        Write-Output $response
    }

    function Get-GDAXFills {
        
        Param(
        [parameter(Mandatory=$false)]$OrderID,
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD")]$ProductID
        )
        $api.url = "/fills"
        $api.method = 'GET'

        if ($OrderID) {$api.url += "?order_id=$OrderID"}
        if ($ProductID) {$api.url += "?product_id=$ProductID"}

        $response = Invoke-Request $api

        Write-Output $response
    }

    function Get-GDAXProductOrderBook {
        
        Param(
        [parameter(Mandatory=$false)][ValidateSet("1","2","3")]$level,
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD")]$ProductID
        )
        $api.url = "/products/$ProductID/book"
        $api.method = 'GET'
        if ($Level) {$api.url += "?level=$level"}
        $response = Invoke-Request $api

        Write-Output $response
    }

    function Get-GDAXProductticker {
        
        Param([parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD")]$ProductID)
        $api.url = "/products/$ProductID/ticker"
        $api.method = 'GET'
        $response = Invoke-Request $api

        Write-Output $response
    }

    function Get-GDAXProductTrades {
        
        Param([parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD")]$ProductID)
        $api.url = "/products/$ProductID/trades"
        $api.method = 'GET'
        $response = Invoke-Request $api

        Write-Output $response
    }

    function Get-GDAXProductStats {
        
        Param([parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD")]$ProductID)
        $api.url = "/products/$ProductID/stats"
        $api.method = 'GET'
        $response = Invoke-Request $api

        Write-Output $response
    }

    # Post Requests

    function New-GDAXLimitOrder {

        Param(
            [parameter(Mandatory=$true)][ValidateSet("sell","buy")]$Side,
            [parameter(Mandatory=$true)][int]$Price,
            [parameter(Mandatory=$true)][int]$Size,
            [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD")]$ProductID,
            [parameter(Mandatory=$false)]$OrderID,
            [parameter(Mandatory=$false)][ValidateSet("dd","co","cn","cb")][string]$STP,
            [parameter(Mandatory=$false)][ValidateSet("GTC","GTT","IOC","FOK")][string]$TimeinForce,
            [parameter(Mandatory=$false)]$CancelAfter,
            [parameter(Mandatory=$false)][ValidateSet("true","false")]$PostOnly
            )

        # Build response 
        $post = @{}
        $post.side = "$side"
        $post.price = "$Price"
        $post.size = "$size"
        $post.product_id = "$ProductID"
        $post.type = "limit"
        if ($OrderID) {$post.client_oid = $OrderID}
        if ($STP) {$post.stp = $STP} 
        if ($TimeinForce) {$post.time_in_force = $TimeinForce}
        if ($CancelAfter) {$post.cancel_after = $CancelAfter}
        if ($PostOnly) {$post.post_only = $PostOnly}


        $api.method = 'POST'
        $api.url = "/orders"
        $api.body = ($post | ConvertTo-Json)
        $response = Invoke-Request $api
        Write-Output $response

    }


    function New-GDAXMarketOrder {
        
                Param(
                    [parameter(Mandatory=$true)][ValidateSet("sell","buy")]$Side,
                    [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD")]$ProductID,
                    [parameter(Mandatory=$false)]$OrderID,
                    [parameter(Mandatory=$false)][ValidateSet("dd","co","cn","cb")][string]$STP,
                    [parameter(Mandatory=$false)][int]$Funds
                    )

                # Build response 
                $post = @{}
                $post.side = "$side"
                $post.funds = "$Funds"
                $post.product_id = "$ProductID"
                $post.type = "market"
                if ($OrderID) {$post.client_oid = $OrderID}
                if ($STP) {$post.stp = $STP}

                $api.method = 'POST'
                $api.url = "/orders"
                $api.body = ($post | ConvertTo-Json)
                $response = Invoke-Request $api
                Write-Output $response
        
            }
        

    
    # Delete requests

    function Stop-GDAXOrder {
        
        Param([parameter(Mandatory=$false)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD")]$ProductID)
        $api.url = "/orders"
        $api.method = 'DELETE'

        if ($ProductID) {$api.url += "?product_id=$ProductID"}

        $response = Invoke-Request $api

        Write-Output $response
    }