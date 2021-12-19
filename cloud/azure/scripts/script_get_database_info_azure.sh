#!/bin/bash

touch dbList
export count=$(az sql server list --query "[] | length(@)")
while [ $count -ge 0 ]
do
   export server=$(az sql server list --query '['"$count"'].{NAME:name'} --output tsv)
   export rg=$(az sql server list --query '['"$count"'].{RG:resourceGroup}' --output tsv)
   az sql db list --resource-group $rg --server $server -query '[].{NAME:name, RG:resourceGroup, LOCATION:location}' --output table >> dbList
   echo Number: $count
   let "count-=1"
done

cat dbList
