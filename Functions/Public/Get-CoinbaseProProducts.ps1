function Get-CoinbaseProProducts {
        
    Param(
    [Parameter(Mandatory=$false)] $APIKey,
    [Parameter(Mandatory=$false)] $APISecret,
    [Parameter(Mandatory=$false)] $APIPhrase,
    [parameter()] [switch] $SandboxAPI                    
    )
    
    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI        
    if ($APIKey) {$api.key = "$APIKey"}
    if ($APISecret) {$api.secret = "$APISecret"}
    if ($APIPhrase) {$api.passphrase = "$APIPhrase"}

    $api.method = 'GET'
    $api.url = "/products"
    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response
}