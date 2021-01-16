function Get-CoinbaseProMarginLiquidationHistory { 
    Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,
        [Parameter()] $After,
        [parameter()] [switch] $SandboxAPI 
    )
    
    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $api.method = 'GET'
    $api.url = '/margin/liquidation_history'
    if ($After) {$api.url = "?after=$After"}

    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response
}