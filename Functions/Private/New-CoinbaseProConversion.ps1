function New-CoinbaseProConversionOrder {

    Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase, 
        [parameter(Mandatory=$true)][ValidateScript({ Test-Currency $_ })]$From,
        [parameter(Mandatory=$true)][ValidateScript({ Test-Currency $_ })]$To,
        [parameter(Mandatory=$true)][int] $Amount,
        [parameter()] [switch] $SandboxAPI
    )

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    # Build response 
    $post = @{}
    $post.from = $From.ToUpper()
    $post.to = $To.ToUpper()
    $post.amount = $Amount

    $api.method = 'POST'
    $api.url = "/conversions"
    $api.body = ($post | ConvertTo-Json)

    Write-Debug -Message "Conversion Order:
    From: $From
    To: $To"

    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response
}