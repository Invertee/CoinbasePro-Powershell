function Get-CoinbaseOrders {
        
    Param(
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase,   
    [parameter(Mandatory=$true)][ValidateScript({ Test-Product $_ })]$ProductID,
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

    $ProductID = $ProductID.toUpper()

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
            if ($array.product) {$api.url += "&product_id=$ProductID"}
            if ($array.status) {$api.url += "&status=$Status"}
            if ($array.before) {$api.url += "&before=$Before"}
            if ($array.after) {$api.url += "&after=$After"}
            if ($array.limit) {$api.url += "&limit=$Limit"}            
        }

        Write-Debug $api.url

        $response = Invoke-CoinbaseRequest $api
        Write-Output $response
    }
}