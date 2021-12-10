# Webserver Script to use in cloud_init

## Linux

```
#!/bin/bash
sudo sudo
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Webserver A" > /var/www/html/index.html
```
```
#!/bin/bash
sudo sudo
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Webserver B" > /var/www/html/index.html
```
