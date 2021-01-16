function Get-CoinbaseProFees { 
        
    Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,
        [parameter()] [switch] $SandboxAPI
    )
    
    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $api.method = 'GET'
    $api.url = '/fees'
    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response
}