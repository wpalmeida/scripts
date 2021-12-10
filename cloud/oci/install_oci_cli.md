# Install OCI CLI

## Ubuntu
```
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" --accept-all-defaults
```
```
oci --version
```
For setup configuration it's necessary to have user ocid, tenancy ocid, region and create the key
```
oci setup config
```

## Reference
https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm
