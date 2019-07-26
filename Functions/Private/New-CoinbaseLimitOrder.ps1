function New-CoinbaseLimitOrder {

    Param(
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase, 
    [parameter(Mandatory=$true)][ValidateSet('sell','buy',IgnoreCase = $false)]$Side,
    [parameter(Mandatory=$true)]$Price,
    [parameter(Mandatory=$true)]$Size,
    [parameter(Mandatory=$true)][ValidateScript({ Test-Product $_ })]$ProductID,
    [parameter()]$OrderID,
    [parameter()][ValidateSet("dd","co","cn","cb")][string]$STP,
    [parameter()][ValidateSet("GTC","GTT","IOC","FOK")][string]$TimeinForce,
    [parameter()]$CancelAfter,
    [parameter()][ValidateSet("true","false")]$PostOnly,
    [parameter()] [switch] $SandboxAPI
    )

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
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

    $response = Invoke-CoinbaseRequest $api
    Write-Output $response

}