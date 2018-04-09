### Powershell Module for accessing the GDAX currency exchange API. 

#### Usage

###### Public Requests
* Get-GDAXProducts - Gets a list of all tradable products on the exchange
* Get-GDAXCurrencies - Lists all currencies on the exchange
* Get-GDAXTime - Gets current time on the exchange
* Get-GDAXProductOrderBook - Gets a list of the orders on the order book for a specific product
* Get-GDAXProductTicker - Gets ticker information for a specific product
* Get-GDAXProductTrades - Get a list of recent trades for a specific product
* Get-GDAXProductStats - Lists stats about a specific product

###### Authenticated Requests
* Get-GDAXAccount - Gets a list of your GDAX accounts
* Get-GDAXAccountHistory - Lists the history of a specific account ID (Paginated)
* Get-GDAXAccountHolds - Lists funds on hold on a specific account ID
* Get-GDAXFills - Lists orders which have filled on a specific account ID (Paginated)
* Get-GDAXOrder - Lists order status for specific order
* Get-GDAXOrders - Lists orders for specific product (Paginated)
* New-GDAXLimitOrder - Creates a new limit order for a product
* New-GDAXMarketOrder - Creates a new market order for a product
* New-GDAXStopOrder - Creates a new stop order for a product
* Stop-GDAXOrder - Cancels a specific order or all orders if no ID is specified for a product. 

#### Authenticating with API key
Keys and secrets are only stored in memory and should be passed to the module when running commands. 
Editing PSDefaultParameterValues can be a useful way of passing the API details to the module.

>$PSDefaultParameterValues = @{"\*GDAX\*:APIKEY" = "KEYHERE";"\*GDAX\*:APIPHRASE" = "PHRASEHERE";"\*GDAX\*:APISECRET" = "SECRETHERE"}