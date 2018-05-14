Login-AzureRmAccount

$dashboardsRG = Get-AzureRmResourceGroup -Name dashboards

Export-AzureRmResourceGroup -ResourceGroupName dashboards -Confirm -Force -IncludeComments -IncludeParameterDefaultValue -Path c:\temp



$uri = "https://management.azure.com/subscriptions/bf031e99-23ef-4cc3-b5a9-b2761eb6126d/resourceGroups/dashboards/providers/Microsoft.Portal/dashboards/a9d278e6-9b95-46fa-b7cf-b79582b6b2de?api-version=2015-08-01-preview"

Invoke-RestMethod -Uri $uri -Method GET -OutFile "c:\temp\dashboard1.json" -PassThru
