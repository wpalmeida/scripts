# OCI Basic Commands
## IAM Commands
```
oci iam compartment list --output table
```
```
oci iam compartment list --compartment-id-in-subtree TRUE --all
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
```
```
oci compute instance get --instance-id <instance-id>
```
```
oci compute instance action --action <START, STOP, etc> --instance-id <instance-id>
```
## Network Commands
```
oci network vcn list -c <compartment-id>
```
```
oci network subnet list -c <compartment-id>
```
```
oci network vlan list -c <compartment-id>
```
```
oci network route-table get --rt-id <route-table-id>
```
## Block Volumes Commands
```
oci bv volume list -c <compartment-id>
```
## DBSystem Commands
```
oci db system list -c <compartment-id>
```
## Query Parameters
```
--query 'data[*].{item:item, item:item}'
```
