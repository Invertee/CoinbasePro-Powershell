    $api = @{
        "endpoint" = 'https://api.gdax.com'
        "url" = ''
        "method" = ''
        "body" = ''
        "key" = ''
        "secret" = ''
        "passphrase" = ''
    }

    function HMAC {

        Param(
        [Parameter()] $message,
        [Parameter()] $secret    
        )

        $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
        $hmacsha.key = [Convert]::FromBase64String($secret)
        $signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($message))
        $signature = [Convert]::ToBase64String($signature)
        return $signature
    }


    function Invoke-Request {

        Param (
        [Parameter()] $request    
        )

        $unixEpochStart = Get-Date -Date "01/01/1970"
        $now = Get-Date
        $timestamp = (New-TimeSpan -Start $unixEpochStart -End $now.ToUniversalTime()).TotalSeconds
        $timestamp = ([math]::Round($timestamp, 3)).ToString()
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
            try {$response = Invoke-RestMethod -Method $request.method -Uri $uri -Headers $header -Body $request.body}
            catch {$Statuscode = $_.Exception.response.Statuscode}
        } else {
            try {$response = Invoke-RestMethod -Method $request.method -Uri $uri -Headers $header}
            catch {$Statuscode = $_.Exception.response.Statuscode}
        }

        if ($Statuscode) {
        if ($Statuscode -eq 400) {Write-Error -Message "Bad Request – Invalid request format"}    
        if ($Statuscode -eq 401) {Write-Error -Message "Unauthorized – Invalid API Key"}  
        if ($Statuscode -eq 403) {Write-Error -Message "Forbidden – You do not have access to the requested resource"}  
        if ($Statuscode -eq 403) {Write-Error -Message "Not Found"}  
        if ($Statuscode -eq 500) {Write-Error -Message "Internal Server Error"} 
        } else {
        return $response  
        }
        

    }


    # Get requests.
    function Get-GDAXAccount { 
        
        Param(
        [Parameter()] [string] $AccountID,
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase
        )
    
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"
    
        $api.method = 'GET'
        $api.url = '/accounts'
        If ($AccountID) {$api.url += "/$AccountID"}
        $response = Invoke-Request $api
        Write-Output $response
    
    }
    
    function Get-GDAXAccountHistory { 
        <#
        TODO: Impliment pagination - https://docs.gdax.com/#pagination
        Only gets last 100 results.
        #>
        Param([parameter(Mandatory=$true)]$AccountID,
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"
        
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
        Param([parameter(Mandatory=$true)]$AccountID,
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.method = 'GET'
        $api.url = "/accounts/$AccountID/holds"
        $response = Invoke-Request $api
        Write-Output $response
    }

    function Get-GDAXProducts {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase                    
        )
        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.method = 'GET'
        $api.url = "/products"
        $response = Invoke-Request $api
        Write-Output $response
    }

    function Get-GDAXCurrencies {   
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase                    
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"                

        $api.method = 'GET'
        $api.url = "/currencies"
        $response = Invoke-Request $api
        Write-Output $response
    }

    function Get-GDAXTime {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase                    
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.method = 'GET'
        $api.url = "/time"
        $response = Invoke-Request $api
        Write-Output $response
    }

    function Get-GDAXFills {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,   
        [parameter()]$OrderID,
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/fills"
        $api.method = 'GET'

        if ($OrderID) {$api.url += "?order_id=$OrderID"}
        if ($ProductID) {$api.url += "?product_id=$ProductID"}

        $response = Invoke-Request $api

        Write-Output $response
    }

    function Get-GDAXOrder {
        
        Param(
        [parameter(Mandatory=$true)]$OrderID,
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase 
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/orders/$OrderID"
        $api.method = 'GET'

        $response = Invoke-Request $api

        Write-Output $response
    }

    function Get-GDAXOrders {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,   
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )
        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/orders"
        $api.method = 'GET'

        if ($ProductID) {$api.url += "?product_id=$ProductID"}

        $response = Invoke-Request $api

        Write-Output $response
    }

    function Get-GDAXProductOrderBook {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,  
        [parameter()][ValidateSet("1","2","3")]$level,
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/products/$ProductID/book"
        $api.method = 'GET'
        if ($Level) {$api.url += "?level=$level"}
        $response = Invoke-Request $api

        Write-Output $response
    }

    function Get-GDAXProductTicker {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/products/$ProductID/ticker"
        $api.method = 'GET'
        $response = Invoke-Request $api

        Write-Output $response
    }

    function Get-GDAXProductTrades {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,     
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/products/$ProductID/trades"
        $api.method = 'GET'
        $response = Invoke-Request $api

        Write-Output $response
    }

    function Get-GDAXProductStats {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )
        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/products/$ProductID/stats"
        $api.method = 'GET'

        $response = Invoke-Request $api

        Write-Output $response
    }



    # Post Requests

    function New-GDAXLimitOrder {

        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateSet('sell','buy',IgnoreCase = $false)]$Side,
        [parameter(Mandatory=$true)]$Price,
        [parameter(Mandatory=$true)]$Size,
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
        [parameter()]$OrderID,
        [parameter()][ValidateSet("dd","co","cn","cb")][string]$STP,
        [parameter()][ValidateSet("GTC","GTT","IOC","FOK")][string]$TimeinForce,
        [parameter()]$CancelAfter,
        [parameter()][ValidateSet("true","false")]$PostOnly
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

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

        Write-Debug -Message "$Side Limit order:
        Size: $Size
        Product: $ProductID
        Price: $Price
        STP: $STP
        Time in Force: $TimeinForce
        Cancel After: $CancelAfter
        Post Only: $PostOnly
        OrderID: $OrderID
        
        API Key: $APIKEY
        API Secret: $APISECRET
        API Phrase: $APIPHRASE
        "


        
        $response = Invoke-Request $api
        Write-Output $response

    }


    function New-GDAXMarketOrder {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateSet('sell','buy',IgnoreCase = $false)]$Side,
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
        [parameter()]$OrderID,
        [parameter()][ValidateSet("dd","co","cn","cb")][string]$STP,
        [parameter()]$Size,
        [parameter()]$Funds
        )

        if ($Size -and $Funds) {
        Write-Error "The size and funds parameters cannot be used together."
        Break
        }
        if (-Not ($Size) -and (-Not($Funds))) {
        Write-Error "Size or Funds parameter required."
        Break
        }

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        # Build response 
        $post = @{}
        $post.side = "$side"
        if ($Size) {$post.size = "$Size"}
        if ($Funds) {$post.funds = "$Funds"}
        $post.product_id = "$ProductID"
        $post.type = "market"
        if ($OrderID) {$post.client_oid = $OrderID}
        if ($STP) {$post.stp = $STP}

        $api.method = 'POST'
        $api.url = "/orders"
        $api.body = ($post | ConvertTo-Json)

        Write-Debug -Message "$Side Market order:
        Size: $Size
        Funds: $Funds
        Product: $ProductID
        STP: $STP
        OrderID: $OrderID"

        $response = Invoke-Request $api
        Write-Output $response
        
    }

    function New-GDAXStopOrder {
                
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateSet('sell','buy',IgnoreCase = $false)]$Side,
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
        [parameter()]$OrderID,
        [parameter(Mandatory=$true)]$Price,
        [parameter()]$Size,
        [parameter()][ValidateSet("dd","co","cn","cb")][string]$STP,
        [parameter()]$Funds
        )

        if ($Size -and $Funds) {
        Write-Error "The size and funds parameters cannot be used together."
        Break
        }
        if (-Not ($Size) -and (-Not($Funds))) {
        Write-Error "Size or Funds parameter required."
        Break
        }
        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        #TODO: Stick some validation for size and funds

        # Build response 
        $post = @{}
        $post.side = "$side"
        $post.price = "$Price"
        $post.product_id = "$ProductID"
        $post.type = "stop"
        if ($OrderID) {$post.client_oid = $OrderID}
        if ($STP) {$post.stp = $STP}
        if ($size) {$post.size = "$size"}
        if ($Funds) {$post.funds = "$Funds"}

        $api.method = 'POST'
        $api.url = "/orders"
        $api.body = ($post | ConvertTo-Json)

        Write-Debug -Message "$Side Stop order:
        Price: $Price
        Size: $Size
        Funds: $Funds
        Product: $ProductID
        STP: $STP
        OrderID: $OrderID"

        $response = Invoke-Request $api
        Write-Output $response
                
    }

    
    # Delete requests

    function Stop-GDAXOrder {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,    
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/orders"
        $api.method = 'DELETE'
        if ($ProductID) {$api.url += "?product_id=$ProductID"}
        $response = Invoke-Request $api
        Write-Output $response
    }