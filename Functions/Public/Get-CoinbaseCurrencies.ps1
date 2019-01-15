function Get-CoinbaseCurrencies {   
        
    Param(
    [Parameter(Mandatory=$false)] $APIKey,
    [Parameter(Mandatory=$false)] $APISecret,
    [Parameter(Mandatory=$false)] $APIPhrase,
    [parameter()] [switch] $SandboxAPI                    
    )

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI        
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"        

    $api.method = 'GET'
    $api.url = "/currencies"
    $response = Invoke-CoinbaseRequest $api
    Write-Output $response
}