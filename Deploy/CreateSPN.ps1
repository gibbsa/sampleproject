I created my service principle with the following:
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionId <Your Subscription Id>  
$sp = New-AzureRmADServicePrincipal -DisplayName PowerShellDemoApp -Password "Pass@word1"
Sleep 20
New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $sp.ApplicationId 

Then I use this to login:
# Login with service principle
$password = "Pass@word1" | ConvertTo-SecureString -asPlainText -Force
$username = "" 
$creds = New-Object System.Management.Automation.PSCredential($username,$password) 
Login-AzureRmAccount -Credential $creds -ServicePrincipal -TenantId "" 
