### Powershell Module for accessing the Coinbase Pro currency exchange API. 

#### Install (Requires PowerShellGet)
> Install-Module -Name CoinbasePro-Powershell

###### Public Requests
* Get-CoinbaseProducts - Gets a list of all tradable products on the exchange
* Get-CoinbaseCurrencies - Lists all currencies on the exchange
* Get-CoinbaseTime - Gets current time on the exchange
* Get-CoinbaseProductOrderBook - Gets a list of the orders on the order book for a specific product
* Get-CoinbaseProductTicker - Gets ticker information for a specific product
* Get-CoinbaseProductTrades - Get a list of recent trades for a specific product
* Get-CoinbaseProductStats - Lists stats about a specific product

###### Authenticated Requests
* Get-CoinbaseAccount - Gets a list of your Coinbase accounts
* Get-CoinbaseAccountHistory - Lists the history of a specific account ID (Paginated)
* Get-CoinbaseAccountHolds - Lists funds on hold on a specific account ID
* Get-CoinbaseFills - Lists orders which have filled on a specific account ID (Paginated)
* Get-CoinbaseOrder - Lists order status for specific order
* Get-CoinbaseOrders - Lists orders for specific product (Paginated)
* New-CoinbaseLimitOrder - Creates a new limit order for a product
* New-CoinbaseMarketOrder - Creates a new market order for a product
* New-CoinbaseStopOrder - Creates a new stop order for a product
* Stop-CoinbaseOrder - Cancels a specific order or all orders if no ID is specified for a product. 

#### Authenticating with API key
Keys and secrets are only stored in memory and should be passed to the module when running commands. 
Editing PSDefaultParameterValues can be a useful way of passing the API details to the module.

>$PSDefaultParameterValues = @{"\*Coinbase\*:APIKEY" = "KEYHERE";"\*Coinbase\*:APIPHRASE" = "PHRASEHERE";"\*Coinbase\*:APISECRET" = "SECRETHERE"}