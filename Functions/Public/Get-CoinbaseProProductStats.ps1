function Get-CoinbaseProProductStats {
    Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateScript({ Test-Product $_ })]$ProductID,
        [parameter()] [switch] $SandboxAPI
    )
    
    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI        
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $ProductID = $ProductID.toLower()

    $api.url = "/products/$ProductID/stats"
    $api.method = 'GET'

    $response = Invoke-CoinbaseProRequest $api

    Write-Output $response
}