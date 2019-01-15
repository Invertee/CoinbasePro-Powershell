function Get-CoinbaseOrder {
        
    Param(
    [parameter(Mandatory=$true)]$OrderID,
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase,
    [parameter()] [switch] $SandboxAPI 
    )

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $ProductID = $ProductID.toLower()

    $api.url = "/orders/$OrderID"
    $api.method = 'GET'

    Write-Debug $api.url
    $response = Invoke-CoinbaseRequest $api
    Write-Output $response
}