function Stop-CoinbaseOrder {
    
    Param(
    [Parameter()] [string] $OrderID,
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase,    
    [parameter()][ValidateScript({Test-Currencies $_})]$ProductID,
    [parameter()] [switch] $SandboxAPI
    )

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

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