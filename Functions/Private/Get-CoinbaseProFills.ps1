function Get-CoinbaseProFills {
        
    Param(
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase,   
    [parameter()]$OrderID,
    [parameter(Mandatory=$true)][ValidateScript({ Test-Product $_ })]$ProductID,
    [Parameter()] $Before,
    [Parameter()] $After,
    [Parameter()] $Limit,
    [parameter()] [switch] $SandboxAPI
    )

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $api.url = "/fills"
    $api.method = 'GET'

    if ($ProductID -and $OrderID) 
    {
        Write-Error "The productID and OrderID parameters cannot be used together."
        Break
    }

    $ProductID = $ProductID.toUpper()

    if ($OrderID -or $ProductID -or $Before -or $After -or $Limit) 
    {
    
        $array = @{}
        if ($OrderID) {$array.Add("order_id","$OrderID")}
        if ($ProductID) {$array.Add("product_id","$ProductID")}
        if ($Before) {$array.Add("before","$Before")}
        if ($After) {$array.Add("after","$After")}
        if ($Limit) {$array.Add("limit","$Limit")}

        $api.url += '?'
        ForEach ($itm in $array) 
        {
            if ($array.order) {$api.url += "&order_id=$OrderID"}
            if ($array.product_id) {$api.url += "&product_id=$ProductID"}
            if ($array.before) {$api.url += "&before=$Before"}
            if ($array.after) {$api.url += "&after=$After"}
            if ($array.limit) {$api.url += "&limit=$Limit"}            
        }

        Write-Debug $api.url
        $response = Invoke-CoinbaseProRequest $api
        Write-Output $response
    }
}