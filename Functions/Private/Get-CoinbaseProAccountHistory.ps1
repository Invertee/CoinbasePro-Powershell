function Get-CoinbaseProAccountHistory { 

    Param([parameter(Mandatory=$true)]$AccountID,
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase,
    [Parameter()] $Before,
    [Parameter()] $After,
    [Parameter()] $Limit = "20",
    [parameter()] [switch] $SandboxAPI
    )

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $api.method = 'GET'
    $api.url = "/accounts/$AccountID/ledger"

    if ($Before -or $After -or $Limit) 
    {
        
        $array = @{}
        if ($Before) {$array.Add("before","$Before")}
        if ($After) {$array.Add("after","$After")}
        if ($Limit) {$array.Add("limit","$Limit")}

        $api.url += '?'
        ForEach ($itm in $array) {
            if ($array.before) {$api.url += "&before=$Before"}
            if ($array.after) {$api.url += "&after=$After"}
            if ($array.limit) {$api.url += "&limit=$Limit"}            
        }
        Write-Debug $api.url

        $response = Invoke-CoinbaseProRequest $api
        Write-Output $response
    }
}