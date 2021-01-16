function Get-CoinbaseProTime {
    Param(
        [Parameter(Mandatory=$false)] $APIKey,
        [Parameter(Mandatory=$false)] $APISecret,
        [Parameter(Mandatory=$false)] $APIPhrase,
        [parameter()] [switch] $SandboxAPI                    
    )

    $api = Get-BlankAPI -SandboxApi:$SandboxAPI 
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $api.method = 'GET'
    $api.url = "/time"
    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response
}