function Get-CoinbaseAccountHolds { 
        
    Param([parameter(Mandatory=$true)]$AccountID,
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
    $api.url = "/accounts/$AccountID/holds"
    $response = Invoke-CoinbaseRequest $api
    Write-Output $response
}