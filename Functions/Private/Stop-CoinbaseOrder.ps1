function Stop-CoinbaseOrder {
    
    Param(
    [Parameter()] [string] $OrderID,
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase,    
    [parameter()][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
    [parameter()] [switch] $SandboxAPI
    )

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $ProductID = $ProductID.toLower()

    if ($OrderID -and $ProductID) 
    {
        Write-Error "The orderID and productID parameters cannot be used together."
        Break
    }

    $api.url = "/orders"
    if ($orderID) {$api.url = "/orders/$OrderID"}
    if ($ProductID) {$api.url += "?product_id=$ProductID"}
    $api.method = 'DELETE'


    $response = Invoke-CoinbaseRequest $api
    Write-Output $response
    }