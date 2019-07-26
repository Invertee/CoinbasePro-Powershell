function New-CoinbaseMarketOrder {
        
    Param(
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase, 
    [parameter(Mandatory=$true)][ValidateSet('sell','buy',IgnoreCase = $false)]$Side,
    [parameter(Mandatory=$true)][ValidateScript({ Test-Product $_ })]$ProductID,
    [parameter()]$OrderID,
    [parameter()][ValidateSet("dd","co","cn","cb")][string]$STP,
    [parameter()]$Size,
    [parameter()]$Funds,
    [parameter()] [switch] $SandboxAPI
    )

    if ($Size -and $Funds) {
        Write-Error "The size and funds parameters cannot be used together."
        Break
    }
    if (-Not ($Size) -and (-Not($Funds))) {
        Write-Error "Size or Funds parameter required."
        Break
    }

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $ProductID = $ProductID.toUpper()

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

    $response = Invoke-CoinbaseRequest $api
    Write-Output $response
    
}