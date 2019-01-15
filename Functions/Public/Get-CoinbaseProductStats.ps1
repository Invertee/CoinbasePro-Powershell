function Get-CoinbaseProductStats {
        
    Param(
    [Parameter(Mandatory=$false)] $APIKey,
    [Parameter(Mandatory=$false)] $APISecret,
    [Parameter(Mandatory=$false)] $APIPhrase, 
    [parameter(Mandatory=$true)][ValidateScript({Test-Currencies $_})]$ProductID,
    [parameter()] [switch] $SandboxAPI
    )
    
    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI        
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $ProductID = $ProductID.toLower()

    $api.url = "/products/$ProductID/stats"
    $api.method = 'GET'

    $response = Invoke-CoinbaseRequest $api

    Write-Output $response
}