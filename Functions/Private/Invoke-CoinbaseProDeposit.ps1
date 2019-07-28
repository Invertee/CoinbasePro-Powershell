function Invoke-CoinbaseProDeposit {

    Param(
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase, 
    [parameter(Mandatory=$true)]$Amount,
    [parameter(Mandatory=$true)][ValidateScript({ Test-Currency $_ })]$Currency,
    [parameter()]$PaymentMethodID,
    [parameter()] $CoinbaseAccountID
    )

    if ($PaymentMethodID -and $CoinbaseAccountID) 
    {
        Write-Error "The PaymentMethodID and CoinbaseAccountID parameters cannot be used together."
        Break
    }

    if (!$PaymentMethodID -and !$CoinbaseAccountID) 
    {
        Write-Error "Requires either the PaymentMethodID or CoinbaseAccountID parameter."
        Break
    }

    $api = Get-BlankAPI -SandboxAPI:$SandboxAPI
    $api.key = "$APIKey"
    $api.secret = "$APISecret"
    $api.passphrase = "$APIPhrase"

    # Build response 
    $post = @{}
    $post.amount = "$Amount"
    $post.currency = "$Currency"

    if ($PaymentMethodID) {
        $api.url = "/deposits/payment-method"
        $post.payment_method_id = $PaymentMethodID
    }
    if ($CoinbaseAccountID) {
        $api.url = "/deposits/coinbase-account"
        $post.coinbase_account_id = $CoinbaseAccountID
    }

    $api.method = 'POST'
    $api.body = ($post | ConvertTo-Json)

    Write-Debug -Message "Deposit:
    Amount: $Amount
    Currency: $Currency
    Payment_Method_ID: $PaymentMethodID
    Coinbase_account_ID: $CoinbaseAccountID"

    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response

}