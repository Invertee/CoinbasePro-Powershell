Get-ChildItem -Path $PSScriptRoot\*.ps1 -Recurse | Foreach-Object{ . $_.FullName }

$FunctionsToExport = @(
    'Get-GDAXAccount',
    'Get-GDAXAccountHistory',
    'Get-GDAXAccountHolds',
    'Get-GDAXProducts',
    'Get-GDAXCurrencies',
    'Get-GDAXTime',
    'Get-GDAXFills',
    'Get-GDAXOrder',
    'Get-GDAXOrders',
    'Get-GDAXProductOrderBook',
    'Get-GDAXProductTicker',
    'Get-GDAXProductTrades',
    'Get-GDAXProductStats',
    'New-GDAXLimitOrder',
    'New-GDAXMarketOrder',
    'New-GDAXStopOrder',
    'Stop-GDAXOrder',
    'Invoke-Request',
    'Get-HMAC'
)

Export-ModuleMember -Function $FunctionsToExport