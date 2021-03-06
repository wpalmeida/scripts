# OCI Basic Commands

## Table of Contents

1. [IAM Commands](#iam-commands)
2. [Compute Commands](#compute-commands)
3. [Network Commands](#network-commands)
4. [Block Volume Commands](#block-volume-commands)
5. [Boot Volume Commands](#boot-volume-commands)
6. [DBSystem Commands](#dbsystem-commands)
7. 

## IAM Commands
```
oci iam compartment list --output table
```
```
oci iam compartment list --compartment-id-in-subtree TRUE --all
```
Command to show all ACTIVE compartments/subcompartments in a table filtered by NAME and OCID
```
oci iam compartment list --compartment-id-in-subtree TRUE --all --query "data[*].{NAME:name, OCDI:id}" --output table --lifecycle-state ACTIVE
```
Command to list only compartment id
```
oci iam compartment list --compartment-id-in-subtree TRUE --all --lifecycle-state ACTIVE --profile <profile> | jq '.data[] | .id' | tr -d \"
```
Listar Availability-Domain
```
oci iam availability-domain list
```
```
oci iam user list
```
```
oci iam group list
```
## Compute Commands
```
oci compute instance list -c <compartment-id>
oci compute instance list -c <compartment-id> --query 'data[*].{name:"display-name", status:"lifecycle-state", id:id}' --output table
```
```
oci compute instance get --instance-id <instance-id>
```
```
oci compute instance list-vnics --instance-id <instance-id>
```
```
oci compute instance action --action <START, STOP, ...> --instance-id <instance-id>
```
## Network Commands
```
oci network vcn list -c <compartment-id>
```
```
oci network subnet list -c <compartment-id>
```
```
oci network subnet list -c <compartment-id> --query 'data[*].{id:id, name:"display-name"}' --output table
```
```
oci network vlan list -c <compartment-id>
```
```
oci network route-table get --rt-id <route-table-id>
```
## Block Volume Commands
```
oci bv volume list -c <compartment-id>
```
## Boot Volume Commands
```
oci bv boot-volume list -c <compartment-id> --availability-domain <AD>
```
## DBSystem Commands
```
oci db system list -c <compartment-id>
```
## Object Storage
Create a bucket
```
oci --profile <profile> os bucket create -c <compartment-id> --name <bucket-name>
```
List buckets in a compartment
```
oci --profile <profile> os bucket list -c <compartment-id>
```
Copy a local file to a bucket
```
oci --profile <profile> os object put -bn <bucket-name> --file <file-name>
```
Copy a a file from a bucket to local compute
```
oci os object get -bn <bucket-name> --file <file-name> --name <file-name>
```
## OCI API raw-reuqest
```
oci raw-request --http-method POST --target-uri https://iaas.sa-saopaulo-1.oraclecloud.com --request-body file://SimpleRequestSummarizedUsagesDetails.json --config-file /home/opc/.oci/config
```
## Query Parameters
```
--query 'data[*].{item:item, item:item}'
```
