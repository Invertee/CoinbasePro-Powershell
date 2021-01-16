function Get-CoinbaseProOrder {
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

    $api.url = "/orders/$OrderID"
    $api.method = 'GET'

    Write-Debug $api.url
    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response
}