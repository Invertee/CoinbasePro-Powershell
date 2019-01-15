function Get-CoinbaseOrders {
        
    Param(
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase,   
    [parameter(Mandatory=$true)][ValidateSet("BTC-GBP","BTC-EUR","ETH-BTC","ETH-EUR","LTC-BTC","LTC-EUR","LTC-USD","ETH-USD","BTC-USD","BCH-USD")]$ProductID,
    [Parameter()][ValidateSet("open","pending","active")] $Status,
    [Parameter()] $Before,
    [Parameter()] $After,
    [Parameter()] $Limit,
    [parameter()] [switch] $SandboxAPI
    )
    
    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $api.url = "/orders"
    $api.method = 'GET'

    $ProductID = $ProductID.toLower()

    if ($Status -or $ProductID -or $Before -or $After -or $Limit) 
    {
        
        $array = @{}
        if ($Status) {$array.Add("status","$Status")}
        if ($ProductID) {$array.Add("product","$ProductID")}
        if ($Before) {$array.Add("before","$Before")}
        if ($After) {$array.Add("after","$After")}
        if ($Limit) {$array.Add("limit","$Limit")}

        $api.url += '?'
        ForEach ($itm in $array) 
        {
            if ($array.status) {$api.url += "&status=$Status"}
            if ($array.product) {$api.url += "&product_id=$ProductID"}
            if ($array.before) {$api.url += "&before=$Before"}
            if ($array.after) {$api.url += "&after=$After"}
            if ($array.limit) {$api.url += "&limit=$Limit"}            
        }

        Write-Debug $api.url

        $response = Invoke-CoinbaseRequest $api
        Write-Output $response
    }
}