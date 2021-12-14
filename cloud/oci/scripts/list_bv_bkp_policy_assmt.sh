#!/bin/bash

echo Which profile do you like?
read profile

# Criar variável apenas com o valor do availability domain
ad=$(oci --profile $profile iam availability-domain list | jq '.data[] | .name' | tr -d \")

# Listar todos os OCID de todos os compartments ativos e salvar no arquivo comaprtmentList
oci --profile $profile iam compartment list --compartment-id-in-subtree TRUE --all --lifecycle-state ACTIVE | jq '.data[] | .id' | tr -d \" > compartmentList
file="compartmentList"

# Listar todos os OCID dos boot-volumes de todos os compartments e salvar no arquivo bvList
while read line
do
  outfile=$(echo $line)
  oci --profile $profile bv boot-volume list -c $line --availability-domain $ad | jq '.data[] | .id' | tr -d \" >> bvList
done < "$file"

# Listar todas os OCID das as atribuções de politica de backup e salvar no arquivo policyAssigment
file="bvList"
while read line
do
  outfile=$(echo $line)
  oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $line | jq '.data[] | .id' | tr -d \" >> policyAssigment
  oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $line | jq '.data[] | ."asset-id"' | tr -d \" >> policyAsset
done < "$file"
