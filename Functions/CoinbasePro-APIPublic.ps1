
    function Get-CoinbaseProducts {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase,
        [parameter()] [switch] $SandboxAPI                    
        )
        
        $api = Get-BlankAPI -SandboxAPI:$SandboxAPI        
        if ($APIKey) {$api.key = "$APIKey"}
        if ($APISecret) {$api.secret = "$APISecret"}
        if ($APIPhrase) {$api.passphrase = "$APIPhrase"}

        $api.method = 'GET'
        $api.url = "/products"
        $response = Invoke-CoinbaseRequest $api
        Write-Output $response
    }

    function Get-CoinbaseCurrencies {   
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase,
        [parameter()] [switch] $SandboxAPI                    
        )

        $api = Get-BlankAPI -SandboxAPI:$SandboxAPI        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"        

        $api.method = 'GET'
        $api.url = "/currencies"
        $response = Invoke-CoinbaseRequest $api
        Write-Output $response
    }

    function Get-CoinbaseTime {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase,
        [parameter()] [switch] $SandboxAPI                    
        )

        $api = Get-BlankAPI -SandboxApi:$SandboxAPI 
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $api.method = 'GET'
        $api.url = "/time"
        $response = Invoke-CoinbaseRequest $api
        Write-Output $response
    }

    function Get-CoinbaseProductOrderBook {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase,  
        [parameter()][ValidateSet("1","2","3")]$level,
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
        [parameter()] [switch] $SandboxAPI
        )

        $api = Get-BlankAPI -SandboxApi:$SandboxAPI 
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $ProductID = $ProductID.toLower()

        $api.url = "/products/$ProductID/book"
        $api.method = 'GET'
        if ($Level) {$api.url += "?level=$level"}
        $response = Invoke-CoinbaseRequest $api

        Write-Output $response
    }

    function Get-CoinbaseProductTicker {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
        [parameter()] [switch] $SandboxAPI
        )

        $api = Get-BlankAPI -SanAPI:$SandboxAPIPI      
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $ProductID = $ProductID.toLower()

        $api.url = "/products/$ProductID/ticker"
        $api.method = 'GET'
        $response = Invoke-CoinbaseRequest $api

        Write-Output $response
    }

    function Get-CoinbaseProductTrades {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase,     
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
        [parameter()] [switch] $SandboxAPI
        )

        $api = Get-BlankAPI -SandboxAPI:$SandboxAPI        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $ProductID = $ProductID.toLower()

        $api.url = "/products/$ProductID/trades"
        $api.method = 'GET'
        $response = Invoke-CoinbaseRequest $api

        Write-Output $response
    }

    function Get-CoinbaseProductStats {
        
        Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
        [parameter()] [switch] $SandboxAPI
        )
        
        $api = Get-BlankAPI -SandboxAPI:$SandboxAPI        
        $api.key = "$APIKey"
        $api.secret = "$APISecret"
        $api.passphrase = "$APIPhrase"

        $ProductID = $ProductID.toLower()

        $api.url = "/products/$ProductID/stats"
        $api.method = 'GET'

        $response = Invoke-CoinbaseRequest $api

        Write-Output $response
    }

