# Azure basic commands
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
