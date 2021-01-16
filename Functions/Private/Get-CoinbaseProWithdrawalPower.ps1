function Get-CoinbaseProWithdrawalPower { 
    Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase,
        [parameter(Mandatory=$false)][ValidateScript({ Test-Currency $_ })]$Currency,
        [parameter()] [switch] $SandboxAPI 
    )
    
    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    $api.method = 'GET'
    $api.url = '/margin/withdrawal_power'

    if ($Currency) {
        $api.url += "?currency=$($Currency.toUpper())"
    } else {
        $api.url += '_all'
    }

    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response
}