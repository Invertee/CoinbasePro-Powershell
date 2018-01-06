GDAX API Powershell functions which will be moved into a module, work in progress!

Editing PSDefaultParameterValues can be a useful way of passing the API details to the functions like so:

>$PSDefaultParameterValues = @{"\*GDAX\*:APIKEY" = "KEYHERE";"\*GDAX\*:APIPHRASE" = "PHRASEHERE";"\*GDAX\*:APISECRET" = "SECRETHERE"}