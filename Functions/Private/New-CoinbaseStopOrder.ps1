function New-CoinbaseStopOrder {
                
    Param(
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase, 
    [parameter(Mandatory=$true)][ValidateSet('sell','buy',IgnoreCase = $false)]$Side,
    [parameter(Mandatory=$true)][ValidateScript({Test-Currencies $_})]$ProductID,
    [parameter()]$OrderID,
    [parameter(Mandatory=$true)]$Price,
    [parameter()]$Size,
    [parameter()][ValidateSet("dd","co","cn","cb")][string]$STP,
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

    $response = Invoke-CoinbaseRequest $api
    Write-Output $response
            
}