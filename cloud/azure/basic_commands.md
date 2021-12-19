# Azure basic commands

## View and set Azure profile

Using the "jq" Linux utility to see all the Azure profile configured
```
cat .azure/azureProfile.json | jq
```
Show the current account
```
az account show
```
Show all account configured in a table
```
az account list --output table
```
Set the subscription
```
az account set --subscription <subscription-id>
```

## Resource group
List resrouce groups
```
az group list
az group list --output table
az group list --query "[?name=='<rg_name>']"
```
## VM
List VMs
```
az vm list
```
## Query
```
--query "[?location=='westus']"
```

## Reference
https://docs.microsoft.com/pt-br/cli/azure/
