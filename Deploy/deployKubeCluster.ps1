Add-AzureRmAccount

Select-AzureRmSubscription -SubscriptionID ef7e7c06-4e8e-47b7-9ecf-f5f22d8a7b92

New-AzureRmResourceGroup `
    -Name learningdancerK8_RG `
    -Location eastus

New-AzureRmResourceGroupDeployment `
    -Name learningdancerK8 `
    -ResourceGroupName learningdancerK8_RG `
    -TemplateFile _output\learningdancer\azuredeploy.json `
    -TemplateParameterFile _output\learningdancer\azuredeploy.parameters.json