function Get-CoinbaseProMarginInfo { 
    Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,
        [parameter(Mandatory=$true)][ValidateScript({ Test-Product $_ })]$ProductID,
        [parameter()] [switch] $SandboxAPI 
    )
    
    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $api.method = 'GET'
    $api.url = '/margin/profile_information?'
    $api.url += "&product_id=$($ProductID.toUpper())"

    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response
}