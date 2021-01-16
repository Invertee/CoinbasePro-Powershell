function Invoke-CoinbaseProProfileTransfer {
    Param(
        [Parameter(Mandatory=$true)] $APIKey,
        [Parameter(Mandatory=$true)] $APISecret,
        [Parameter(Mandatory=$true)] $APIPhrase, 
        [Parameter(Mandatory=$true)] $Amount,
        [Parameter(Mandatory=$true)][ValidateScript({ Test-Currency $_ })]$Currency,
        [Parameter(Mandatory=$true)] $FromID,
        [Parameter(Mandatory=$true)] $ToID,
        [Parameter()] [switch] $SandboxAPI 
    )

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    # Build response 
    $post = @{}
    $post.amount = "$Amount"
    $post.currency = "$Currency"
    $post.from = "$FromID"
    $post.to = "$ToID"

    $api.url = "/profiles/transfer"

    $api.method = 'POST'
    $api.body = ($post | ConvertTo-Json)

    Write-Debug -Message "Deposit:
    Amount: $Amount
    Currency: $Currency
    From_Profile_Id: $FromID
    To_Profile_Id: $ToID"

    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response
}