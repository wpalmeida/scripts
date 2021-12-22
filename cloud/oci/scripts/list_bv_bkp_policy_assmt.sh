#!/bin/bash

echo Which profile do you like?
read profile

# Criar variável apenas com o valor do availability domain
ad=$(oci --profile $profile iam availability-domain list --query 'data[0].name' --raw-output)

export count_compart_id=$(oci --profile $profile iam compartment list --compartment-id-in-subtree TRUE --all --lifecycle-state ACTIVE --query 'data[] | length(@)')

# Listar todos os OCID de todos os compartments ativos e salvar no arquivo comaprtmentList
#oci --profile $profile iam compartment list --compartment-id-in-subtree TRUE --all --lifecycle-state ACTIVE --query 'data[*].id' --raw-output > compartmentList
#compartmentList="compartmentList"

while [ $count_compart_id -ge 0 ]
do
   export compart_id=$(oci --profile $profile iam compartment list --compartment-id-in-subtree TRUE --all --lifecycle-state ACTIVE --query 'data['"$count_compart_id"'].id' --raw-output)
   export count_boot_id=$(oci --profile $profile bv boot-volume list -c $compart_id --availability-domain $ad --query 'data[] | length(@)')
   while [ $count_boot_id -ge 0 ]
   do
      export boot_id=$(oci --profile $profile bv boot-volume list -c $compart_id --availability-domain $ad --query 'data['"$count_boot_id"'].id' --raw-output)
      oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $boot_id --query 'data[*].id' --raw-output  >> policyAssigmentBootVolume
      echo $boot_id
      let "count_boot_id-=1"
   done
   let "count_compart_id-=1"
done


# Listar todos os OCID dos boot-volumes de todos os compartments e salvar no arquivo bvList
while read line
do
  outfile=$(echo $line)
  oci --profile $profile bv boot-volume list -c $line --availability-domain $ad --query 'data[*].id' --raw-output >> bootList
  oci --profile $profile bv volume list -c $line --query 'data[*].id' --raw-output >> volumeList
done < "$compartmentList"

# Listar todas os OCID das as atribuções de politica de backup dos Boot Volumes e salvar no arquivo policyAssigment
bootList="bootList"
while read line
do
  outfile=$(echo $line)
  oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $line --query 'data[*].id' --raw-output  >> policyAssigmentBootVolume
  oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $line --query 'data[*]."asset-id"' --raw-output >> policyAssetBootVolume
done < "$bootList"

diff bootList policyAssetBootVolume | grep ocid | tr -d \< > bootWithoutPolicy

# Listar todas os OCID das as atribuções de politica de backup dos Block Volumes e salvar no arquivo policyAssigment
volumeList="volumeList"
while read line
do
  outfile=$(echo $line)
  oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $line --query 'data[*].id' --raw-output  >> policyAssigmentBlockVolume
  oci --profile $profile bv volume-backup-policy-assignment get-volume-backup-policy-asset-assignment --asset-id $line --query 'data[*]."asset-id"' --raw-output  >> policyAssetBlockVolume
done < "$volumeList"

diff volumeList policyAssetBlockVolume | grep ocid | tr -d \< > volumeWithoutPolicy


# oci compute boot-volume-attachment list -c $willian --availability-domain FOjF:SA-SAOPAULO-1-AD-1
