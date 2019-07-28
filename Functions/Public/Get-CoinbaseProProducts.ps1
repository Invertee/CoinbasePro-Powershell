function Get-CoinbaseProProducts {
        
    Param(
    [Parameter(Mandatory=$false)] $APIKey,
    [Parameter(Mandatory=$false)] $APISecret,
    [Parameter(Mandatory=$false)] $APIPhrase,
    [Parameter(Mandatory=$false)] [scriptblock] $Filter,
    [parameter()] [switch] $SandboxAPI                    
    )
    
    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI        
    if ($APIKey) {$api.key = "$APIKey"}
    if ($APISecret) {$api.secret = "$APISecret"}
    if ($APIPhrase) {$api.passphrase = "$APIPhrase"}

    $api.method = 'GET'
    $api.url = "/products"
    $response = Invoke-CoinbaseProRequest $api

    if ($Filter) {
        $response = $response | Where-Object -FilterScript $Filter
    }

    Write-Output $response
}