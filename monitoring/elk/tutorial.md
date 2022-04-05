# Cluster ELK

## Construir Infraestrutura
- Elastichsearch: 03 Nodes
- Kibana: 01 Node
- Logstash: 01 Node

## Requisitos
- Ubuntu
- 1 OCPU
- 16 GB

## Instalar o Elasticsearch

```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
```
```
sudo apt-get install apt-transport-https
```
```
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
```
```
sudo apt-get update && sudo apt-get install elasticsearch
```
```
sudo /bin/systemctl daemon-reload
```
```
sudo /bin/systemctl enable elasticsearch.service
```
```
sudo systemctl start elasticsearch.service
```
```
sudo systemctl stop elasticsearch.service
```

### Ingressar nodes ao cluster após a instalação

```
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node
```
```
/usr/share/elasticsearch/bin/elasticsearch-reconfigure-node --enrollment-token <enrollment-token>
```
```
sudo /bin/systemctl daemon-reload
```
```
sudo /bin/systemctl enable elasticsearch.service
```
```
sudo systemctl start elasticsearch.service
```
```
sudo systemctl stop elasticsearch.service
```