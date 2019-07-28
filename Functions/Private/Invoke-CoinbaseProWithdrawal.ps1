function Invoke-CoinbaseProWithdrawal {

    Param(
    [Parameter(Mandatory=$true)] $APIKey,
    [Parameter(Mandatory=$true)] $APISecret,
    [Parameter(Mandatory=$true)] $APIPhrase, 
    [parameter(Mandatory=$true)]$Amount,
    [parameter(Mandatory=$true)][ValidateScript({ Test-Currency $_ })]$Currency,
    [parameter()]$PaymentMethodID,
    [parameter()] $CoinbaseAccountID,
    [parameter()] $CryptoAddress,
    [parameter()] $DestinationTag 
    )

    if (($PaymentMethodID -and ($CoinbaseAccountID -or $CryptoAddress)) -or ($CoinbaseAccountID -and ($PaymentMethodID -or $CryptoAddress))) 
    {
        Write-Error "The PaymentMethodID, CoinbaseAccountID and CryptoAddress parameters cannot be used together."
        Break
    }
    if (!$PaymentMethodID -and !$CoinbaseAccountID -and !$CryptoAddress) 
    {
        Write-Error "Requires either the CryptoAddress, PaymentMethodID or CoinbaseAccountID parameter."
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
        $api.url = "/withdrawals/payment-method"
        $post.payment_method_id = $PaymentMethodID
    }
    if ($CoinbaseAccountID) {
        $api.url = "/withdrawals/coinbase-account"
        $post.coinbase_account_id = $CoinbaseAccountID
    }
    if ($CryptoAddress) {
        $api.url = "/withdrawals/crypto"
        $post.crypto_address = $CryptoAddress
        if ($DestinationTag) {
            $post.destination_tag = $DestinationTag
            $post.no_destination_tag = 'false'
        } else {
            $post.no_destination_tag = 'true'
        }
    }

    $api.method = 'POST'
    $api.body = ($post | ConvertTo-Json)

    Write-Debug -Message "Deposit:
    Amount: $Amount
    Currency: $Currency
    Payment_Method_ID: $PaymentMethodID
    Coinbase_account_ID: $CoinbaseAccountID
    Crypto_Address: $CryptoAddress
    Destination_tag: $DestinationTag"

    $response = Invoke-CoinbaseProRequest $api
    Write-Output $response

}