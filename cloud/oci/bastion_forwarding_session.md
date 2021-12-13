# How to use bastion service on OCI

1. Create a bastion
- Define a target network
- Define a target subnet
- Define a source IP address
2. Create a session
- Define a session type (SSH port forwarding session)
- Define a name
- Select the instance
- Upload or create your public key
3. Connect to your instance
- Coppy SSH command
```
ssh -i <privateKey> -N -L <localPort>:10.0.1.54:22 -p 22 ocid1.bastionsession.oc1.sa-saopaulo-1.amaaaaaampwzjdiaoxlqspij2vsl6ypjo7bbzsmwsebuspasvehxonm7aioa@host.bastion.sa-saopaulo-1.oci.oraclecloud.com
```
- Change the privateKey and localPort parameters
- Connect
- In another session connect your instance trough your session using the command below
```
ssh -i <privateKey> <user>@127.0.0.1 -p <localPort> -v
```
