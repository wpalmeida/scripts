# Bastion CLI commands
List bastion in a compartment filtered by ACTIVE presented in a table
```
oci bastion bastion list -c <compartment-id> --all --query 'data[*].{id:id, state:"lifecycle-state", name:name}' --output table
```
Criar bastion
```
```
Delete bastion
```
oci bastion bastion delete --bastion-id <bastion-id>
```
# Bastion sessions CLI commands
Create a bastion session
```
oci bastion session create-port-forwarding --display-name "<display-name>" --bastion-id <bastion-id> --ssh-public-key-file <public-key-file> --target-private-ip "<target-private-ip>"
```
List ACTIVE bastion sessions
```
oci bastion session list --bastion-id <bastion-id> --all --session-lifecycle-state ACTIVE
```
Get detail information about bastion session like command to connect to the session
```
oci bastion session get --session-id <session-id>
```
Delete bastion session
```
oci bastion session delete --session-id <session-id>
```
## Reference
https://docs.oracle.com/en-us/iaas/tools/oci-cli/2.25.1/oci_cli_docs/cmdref/bastion.html
