    $api = @{
        "endpoint" = 'https://api.gdax.com'
        "url" = ''
        "method" = ''
        "body" = ''
        "key" = ''
        "secret" = ''
        "passphrase" = ''
    }
    
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

        Param([parameter(Mandatory=$true)]$AccountID,
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,
        [Parameter()] $Before,
        [Parameter()] $After,
        [Parameter()] $Limit = "20"
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.method = 'GET'
        $api.url = "/accounts/$AccountID/ledger"

        if ($Before -or $After -or $Limit) {
            
            $array = @{}
            if ($Before) {$array.Add("before","$Before")}
            if ($After) {$array.Add("after","$After")}
            if ($Limit) {$array.Add("limit","$Limit")}
    
            $api.url += '?'
            ForEach ($itm in $array) {
                if ($array.before) {$api.url += "&before=$Before"}
                if ($array.after) {$api.url += "&after=$After"}
                if ($array.limit) {$api.url += "&limit=$Limit"}            
            }
            Write-Debug $api.url

        $response = Invoke-Request $api
        Write-Output $response
    }
}

    function Get-GDAXAccountHolds { 
        
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

    function Get-GDAXFills {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,   
        [parameter()]$OrderID,
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
        [Parameter()] $Before,
        [Parameter()] $After,
        [Parameter()] $Limit
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/fills"
        $api.method = 'GET'
        if ($OrderID -or $ProductID -or $Before -or $After -or $Limit) {
        
        $array = @{}
        if ($OrderID) {$array.Add("order","$OrderID")}
        if ($ProductID) {$array.Add("product","$ProductID")}
        if ($Before) {$array.Add("before","$Before")}
        if ($After) {$array.Add("after","$After")}
        if ($Limit) {$array.Add("limit","$Limit")}

        $api.url += '?'
        ForEach ($itm in $array) {
            if ($array.order) {$api.url += "&order_id=$OrderID"}
            if ($array.product) {$api.url += "&product_id=$ProductID"}
            if ($array.before) {$api.url += "&before=$Before"}
            if ($array.after) {$api.url += "&after=$After"}
            if ($array.limit) {$api.url += "&limit=$Limit"}            
        }

        Write-Debug $api.url
        $response = Invoke-Request $api
        Write-Output $response
    }
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

        Write-Debug $api.url
        $response = Invoke-Request $api
        Write-Output $response
    }

    function Get-GDAXOrders {
        
        Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,   
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
        [Parameter()][ValidateSet("open","pending","active")] $Status,
        [Parameter()] $Before,
        [Parameter()] $After,
        [Parameter()] $Limit
        )
        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/orders"
        $api.method = 'GET'

        if ($Status -or $ProductID -or $Before -or $After -or $Limit) {
            
            $array = @{}
            if ($Status) {$array.Add("status","$Status")}
            if ($ProductID) {$array.Add("product","$ProductID")}
            if ($Before) {$array.Add("before","$Before")}
            if ($After) {$array.Add("after","$After")}
            if ($Limit) {$array.Add("limit","$Limit")}
    
            $api.url += '?'
            ForEach ($itm in $array) {
                if ($array.status) {$api.url += "&status=$Status"}
                if ($array.product) {$api.url += "&product_id=$ProductID"}
                if ($array.before) {$api.url += "&before=$Before"}
                if ($array.after) {$api.url += "&after=$After"}
                if ($array.limit) {$api.url += "&limit=$Limit"}            
            }
    
            Write-Debug $api.url

        $response = Invoke-Request $api
        Write-Output $response
    }
}

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
        OrderID: $OrderID"

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

        function Stop-GDAXOrder {
        
        Param(
        [Parameter()] [string] $OrderID,
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,    
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )

        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/orders"
        if ($orderID) {$api.url = "/orders/$OrderID"}
        $api.method = 'DELETE'
        if ($ProductID) {$api.url += "?product_id=$ProductID"}

        $response = Invoke-Request $api
        Write-Output $response
        }
    