Get-ChildItem -Path $PSScriptRoot -Recurse -File | Unblock-File
Get-ChildItem -Path $PSScriptRoot\*.ps1 -Recurse | Foreach-Object{ . $_.FullName }

$FunctionsToExport = @(
    'Get-CoinbaseAccounts',
    'Get-CoinbaseProAccounts',
    'Get-CoinbaseProAccountHistory',
    'Get-CoinbaseProFees',
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
    'New-CoinbaseProConversionOrder',
    'Get-CoinbaseProPaymentMethods',
    'Invoke-CoinbaseProDeposit',
    'Invoke-CoinbaseProWithdrawal',
    'Remove-CoinbaseProOrder',
    'Get-CoinbaseProTransfers',
    'Get-CoinbaseProProfiles',
    'Get-CoinbaseProProfile',
    'Invoke-CoinbaseProProfileTransfer',
    'Get-CoinbaseProMarginInfo',
    'Get-CoinbaseProBuyingPower',
    'Get-CoinbaseProWithdrawalPower'
)

$CBProducts = Get-CoinbaseProProducts 
$CBCurrencies = Get-CoinbaseProCurrencies 

if (!$CBProducts -or !$CBCurrencies) {
    Throw "Unable to import Coinbase Pro products & currencies."
    Break
} else {
    $CBProducts | select-object id | ConvertTo-Csv | out-file "$([system.io.path]::GetTempPath())/CoinbaseProPS-products.csv" -Force
    $CBCurrencies | select-object id | ConvertTo-Csv | out-file "$([system.io.path]::GetTempPath())CoinbaseProPS-currencies.csv" -Force
    Write-Host "Coinbase Pro Module Imported: $($CBProducts.count) Tradable Products and $($CBCurrencies.count) Currencies" -ForegroundColor Green
}

$Products = {
    $CBProducts | Select-Object -ExpandProperty id | ForEach-Object {
        "$_"
    }
}

$Currencies = {
    $CBCurrencies | Select-Object -ExpandProperty id | ForEach-Object {
        "$_"
    }
}

$ProductFunctions = @(
    'New-CoinbaseProLimitOrder',
    'Get-CoinbaseProFills',
    'New-CoinbaseProMarketOrder',
    'New-CoinbaseProStopOrder',
    'Get-CoinbaseProOrders',
    'Remove-CoinbaseProOrder',
    'Get-CoinbaseProProductOrderBook',
    'Get-CoinbaseProProductStats',
    'Get-CoinbaseProProductTicker',
    'Get-CoinbaseProProductTrades',
    'Get-CoinbaseProMarginMarginInfo',
    'Get-CoinbaseProMarginBuyingPower'
)

Foreach ($function in $ProductFunctions) {
    Register-ArgumentCompleter -CommandName $function -ParameterName 'ProductID' -ScriptBlock $Products
}

$CurrencyFunctions = @(
    'New-CoinbaseProConversionOrder',
    'Get-CoinbaseProMarginWithdrawalPower'
)

Foreach ($function in $CurrencyFunctions) {
    Register-ArgumentCompleter -CommandName $function -ParameterName 'To' -ScriptBlock $Currencies
    Register-ArgumentCompleter -CommandName $function -ParameterName 'From' -ScriptBlock $Currencies
    Register-ArgumentCompleter -CommandName $function -ParameterName 'Currency' -ScriptBlock $Currencies
}

Export-ModuleMember -Function $FunctionsToExport