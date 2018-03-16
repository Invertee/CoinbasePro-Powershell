## Powershell Module for accessing the public and authenticated GDAX currency exchange API. 

## Authenticating with API key
Keys and secrets are only stored in memory and should be passed to the module when running commands. 
Editing PSDefaultParameterValues can be a useful way of passing the API details to the module.

>$PSDefaultParameterValues = @{"\*GDAX\*:APIKEY" = "KEYHERE";"\*GDAX\*:APIPHRASE" = "PHRASEHERE";"\*GDAX\*:APISECRET" = "SECRETHERE"}