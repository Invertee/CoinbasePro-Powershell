### Powershell Module for accessing the Coinbase Pro currency exchange API. 

#### Install (Requires PowerShellGet)
> Install-Module -Name CoinbasePro-Powershell

###### Public Requests
* Get-CoinbaseProProducts - Gets a list of all tradable products on the exchange
* Get-CoinbaseProCurrencies - Lists all currencies on the exchange
* Get-CoinbaseProTime - Gets current time on the exchange
* Get-CoinbaseProProductOrderBook - Gets a list of the orders on the order book for a specific product
* Get-CoinbaseProProductTicker - Gets ticker information for a specific product
* Get-CoinbaseProProductTrades - Get a list of recent trades for a specific product
* Get-CoinbaseProProductStats - Lists stats about a specific product

###### Authenticated Requests
* Get-CoinbaseProAccount - Gets a list of your Coinbase accounts
* Get-CoinbaseProAccountHistory - Lists the history of a specific account ID (Paginated)
* Get-CoinbaseProAccountHolds - Lists funds on hold on a specific account ID
* Get-CoinbaseProFills - Lists orders which have filled on a specific account ID (Paginated)
* Get-CoinbaseProOrder - Lists order status for specific order
* Get-CoinbaseProOrders - Lists orders for specific product (Paginated)
* New-CoinbaseProLimitOrder - Creates a new limit order for a product
* New-CoinbaseProMarketOrder - Creates a new market order for a product
* New-CoinbaseProStopOrder - Creates a new stop order for a product
* Stop-CoinbaseProOrder - Cancels a specific order or all orders if no ID is specified for a product. 

#### Authenticating with API key
Keys and secrets are only stored in memory and should be passed to the module when running commands. 
Editing PSDefaultParameterValues can be a useful way of passing the API details to the module.

>$PSDefaultParameterValues = @{"\*Coinbase\*:APIKEY" = "KEYHERE";"\*Coinbase\*:APIPHRASE" = "PHRASEHERE";"\*Coinbase\*:APISECRET" = "SECRETHERE"}