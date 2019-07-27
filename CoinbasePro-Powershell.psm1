Get-ChildItem -Path $PSScriptRoot\*.ps1 -Recurse | Foreach-Object{ . $_.FullName }

$FunctionsToExport = @(
    'Get-CoinbaseAccounts',
    'Get-CoinbaseProAccounts',
    'Get-CoinbaseProAccountHistory',
    'Get-CoinbaseProAccountHolds',
    'Get-CoinbaseProProducts',
    'Get-CoinbaseProCurrencies',
    'Get-CoinbaseProTime',
    'Get-CoinbaseProFills',
    'Get-CoinbaseProOrder',
    'Get-CoinbaseProOrders',
    'Get-CoinbaseProProductOrderBook',
    'Get-CoinbaseProProductTicker',
    'Get-CoinbaseProProductTrades',
    'Get-CoinbaseProProductStats',
    'New-CoinbaseProLimitOrder',
    'New-CoinbaseProMarketOrder',
    'New-CoinbaseProStopOrder',
    'Get-CoinbaseProPaymentMethods',
    'Remove-CoinbaseProOrder',
    'Invoke-CoinbaseProRequest',
    'Get-BlankAPI',
    'Get-HMAC',
    'Test-Currencies'

)
$CBProducts = Get-CoinbaseProProducts

if (!$CBProducts) {
    Throw "Unable to import Coinbase Pro products."
    Break
} else {
    $CBProducts | Select-Object | ConvertTo-Csv | out-file "$env:APPDATA/CoinbaseProPS-products.csv" -Force
    Write-Host "Coinbase Pro products imported" -ForegroundColor Green
}

Export-ModuleMember -Function $FunctionsToExport