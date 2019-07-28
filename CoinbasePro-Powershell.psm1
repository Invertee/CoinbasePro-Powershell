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

$ProductsScriptBlock = {
    $CBProducts | Select-Object -ExpandProperty id | ForEach-Object {
        "$_"
    }
}

Register-ArgumentCompleter -CommandName Get-CoinbaseProOrders -ParameterName ProductID -ScriptBlock $ProductsScriptBlock
Register-ArgumentCompleter -CommandName Get-CoinbaseProFills -ParameterName ProductID -ScriptBlock $ProductsScriptBlock
Register-ArgumentCompleter -CommandName New-CoinbaseProLimitOrder -ParameterName ProductID -ScriptBlock $ProductsScriptBlock
Register-ArgumentCompleter -CommandName New-CoinbaseProMarketOrder -ParameterName ProductID -ScriptBlock $ProductsScriptBlock
Register-ArgumentCompleter -CommandName New-CoinbaseProStopOrder -ParameterName ProductID -ScriptBlock $ProductsScriptBlock
Register-ArgumentCompleter -CommandName Remove-CoinbaseProOrder -ParameterName ProductID -ScriptBlock $ProductsScriptBlock
Register-ArgumentCompleter -CommandName Get-CoinbaseProProductOrderBook -ParameterName ProductID -ScriptBlock $ProductsScriptBlock
Register-ArgumentCompleter -CommandName Get-CoinbaseProProductStats -ParameterName ProductID -ScriptBlock $ProductsScriptBlock
Register-ArgumentCompleter -CommandName Get-CoinbaseProProductTicker -ParameterName ProductID -ScriptBlock $ProductsScriptBlock
Register-ArgumentCompleter -CommandName Get-CoinbaseProProductTrades -ParameterName ProductID -ScriptBlock $ProductsScriptBlock

Export-ModuleMember -Function $FunctionsToExport