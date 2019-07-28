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
    'Invoke-CoinbaseProDeposit',
    'Invoke-CoinbaseProWithdrawal',
    'Remove-CoinbaseProOrder'
)

$CBProducts = Get-CoinbaseProProducts 
$CBCurrencies = Get-CoinbaseProCurrencies 

if (!$CBProducts -or !$CBCurrencies) {
    Throw "Unable to import Coinbase Pro products & currencies."
    Break
} else {
    $CBProducts | select-object id | ConvertTo-Csv | out-file "$env:APPDATA/CoinbaseProPS-products.csv" -Force
    $CBCurrencies | select-object id | ConvertTo-Csv | out-file "$env:APPDATA/CoinbaseProPS-currencies.csv" -Force
    Write-Host "Coinbase Pro products and currencies imported" -ForegroundColor Green
}

Export-ModuleMember -Function $FunctionsToExport