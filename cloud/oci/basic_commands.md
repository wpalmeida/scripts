# OCI Basic Commands
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
## Query Parameters
```
--query 'data[*].{item:item, item:item}'
```
