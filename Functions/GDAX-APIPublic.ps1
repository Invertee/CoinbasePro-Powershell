
    function Get-GDAXProducts {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase                    
        )
        
        $api = Get-BlankAPI        
        if ($APIKey) {$api.key = "$APIKey"}
        if ($APISecret) {$api.secret = "$APISecret"}
        if ($APIPhrase) {$api.passphrase = "$APIPhrase"}

        $api.method = 'GET'
        $api.url = "/products"
        $response = Invoke-GDAXRequest $api
        Write-Output $response
    }

    function Get-GDAXCurrencies {   
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase                    
        )

        $api = Get-BlankAPI        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"        

        $api.method = 'GET'
        $api.url = "/currencies"
        $response = Invoke-GDAXRequest $api
        Write-Output $response
    }

    function Get-GDAXTime {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase                    
        )

        $api = Get-BlankAPI 
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.method = 'GET'
        $api.url = "/time"
        $response = Invoke-GDAXRequest $api
        Write-Output $response
    }

    function Get-GDAXProductOrderBook {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase,  
        [parameter()][ValidateSet("1","2","3")]$level,
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )

        $api = Get-BlankAPI 
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/products/$ProductID/book"
        $api.method = 'GET'
        if ($Level) {$api.url += "?level=$level"}
        $response = Invoke-GDAXRequest $api

        Write-Output $response
    }

    function Get-GDAXProductTicker {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )

        $api = Get-BlankAPI      
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/products/$ProductID/ticker"
        $api.method = 'GET'
        $response = Invoke-GDAXRequest $api

        Write-Output $response
    }

    function Get-GDAXProductTrades {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase,     
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )

        $api = Get-BlankAPI        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/products/$ProductID/trades"
        $api.method = 'GET'
        $response = Invoke-GDAXRequest $api

        Write-Output $response
    }

    function Get-GDAXProductStats {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID
        )
        
        $api = Get-BlankAPI        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.url = "/products/$ProductID/stats"
        $api.method = 'GET'

        $response = Invoke-GDAXRequest $api

        Write-Output $response
    }

