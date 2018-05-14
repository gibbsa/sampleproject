<#
 .SYNOPSIS
    Deploys a template to Azure

 .DESCRIPTION
    Deploys an Azure Resource Manager template

 .PARAMETER subscriptionId
    The subscription id where the template will be deployed.

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

.PARAMETER deploymentName
    Optional name of the deployment. If not specified a default name is generated.

 .PARAMETER resourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER templateFilePath
    Optional, path to the template file. Defaults to template.json.

 .PARAMETER parametersFilePath
    Optional, path to the parameters file. Defaults to AzureWebHelloWorld.json. If file is not found, will prompt for parameter values based on template.

 .PARAMETER incremental
    Optional flag indicating deployment mode should be incremental and not complete (default).
#>

param(
 [Parameter(Mandatory=$True)]
 [string]
 $subscriptionId,

 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName,

 [string]
 $deploymentName = $null,

 [string]
 $resourceGroupLocation = "East US",

 [string]
 $templateFilePath = "AzureWebHelloWorld.json",

 [string]
 $parametersFilePath = "parameters.json", 

 [switch]
 $incremental
)

$mode = "Complete";

if ($incremental) {
    $mode = "Incremental";
}

if (!$deploymentName) {
    $deploymentName = "Deploy_{0}" -f (get-date -format M.d.yyyy-hh.mm.ss);
}

<#
.SYNOPSIS
    Registers Resource Providers
#>
Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Host "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# sign in
#Write-Host "Logging in...";
#Login-AzureRmAccount;

# select subscription
#Write-Host "Selecting subscription '$subscriptionId'";
Select-AzureRmSubscription -SubscriptionID $subscriptionId;

# Register RPs
$resourceProviders = @("microsoft.insights","microsoft.web");
if($resourceProviders.length) {
    Write-Host "Registering resource providers"
    foreach($resourceProvider in $resourceProviders) {
        RegisterRP($resourceProvider);
    }
}

#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
    if(!$resourceGroupLocation) {
        $resourceGroupLocation = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}

# Start the deployment
Write-Host "Starting deployment...";
if(Test-Path $parametersFilePath) {
    New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath -Mode $mode -Force;
} else {
    New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -Mode $mode -Force;
}


cd "C:\Users\shawngib\Documents\Templates\ACS\_output\Kube_OMS\samplecoreapp\Deploy"
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted
.\AzureWebHelloWorld.ps1 -subscriptionId "bf031e99-23ef-4cc3-b5a9-b2761eb6126d" -resourceGroupName SampleWithSQLAppInsights -parametersFilePath AzureWebHelloWorldDev.json


get-azurermcontext

Get-AzureRmOperationalInsightsWorkspace

New-Guid

Remove-AzureRmResourceGroup -Name SampleWithSQLAppInsights