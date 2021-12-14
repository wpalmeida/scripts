#!/bin/bash

echo Which profile do you like?
read profile

# Criar variável apenas com o valor do availability domain
ad=$(oci --profile $profile iam availability-domain list | jq '.data[] | .name' | tr -d \")

# Listar todos os OCID de todos os compartments ativos e salvar no arquivo comaprtmentList
oci --profile $profile iam compartment list --compartment-id-in-subtree TRUE --all --lifecycle-state ACTIVE | jq '.data[] | .id' | tr -d \" > compartmentList
compartmentList="compartmentList"

# Listar todos os OCID dos boot-volumes de todos os compartments e salvar no arquivo bvList
while read line
do
  outfile=$(echo $line)
  oci --profile $profile bv boot-volume list -c $line --availability-domain $ad | jq '.data[] | .id' | tr -d \" >> bootList
  oci --profile $profile bv volume list -c $line | jq '.data[] | .id' | tr -d \" >> volumeList
done < "$compartmentList"

# Listar todas os OCID das as atribuções de politica de backup dos Boot Volumes e salvar no arquivo policyAssigment
bootList="bootList"
while read line
do
  outfile=$(echo $line)
  oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $line | jq '.data[] | .id' | tr -d \" >> policyAssigmentBootVolume
  oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $line | jq '.data[] | ."asset-id"' | tr -d \" >> policyAssetBootVolume
done < "$bootList"

diff bootList policyAssetBootVolume | grep ocid | tr -d \< > bootWithoutPolicy

# Listar todas os OCID das as atribuções de politica de backup dos Block Volumes e salvar no arquivo policyAssigment
volumeList="volumeList"
while read line
do
  outfile=$(echo $line)
  oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $line | jq '.data[] | .id' | tr -d \" >> policyAssigmentBlockVolume
  oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $line | jq '.data[] | ."asset-id"' | tr -d \" >> policyAssetBlockVolume
done < "$volumeList"

diff vplumeList policyAssetBlockVolume | grep ocid | tr -d \< > volumeWithoutPolicy


# oci compute boot-volume-attachment list -c $willian --availability-domain FOjF:SA-SAOPAULO-1-AD-1
