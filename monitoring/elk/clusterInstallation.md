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
- [DOC Reference](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html)

```
sudo apt update
```
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
- -Save the password generated to the user elastic

- Follow to the next step this node is the first node in the cluster, otherwise go to Ingressasr nodes ao clsuters apóis a instalação
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
sudo systemctl status elasticsearch.service
```
- If needed you can stop the service
```
sudo systemctl stop elasticsearch.service
```

### Configure Elasticserach

- Edit the file elasticsearch.yml
```
sudo vim /etc/elasticsearch/elasticsearch.yml
```
- Uncomment and change this lines
```
cluster.name: my-application
node.name: node-1
http.port: 9200
network.host: 0.0.0.0
```
```
sudo systemctl stop elasticsearch.service
sudo systemctl start elasticsearch.service
sudo systemctl status elasticsearch.service
```

### Ingressar nodes ao cluster após a instalação

- Generate the token in existing node in order to ingress another node to the cluster
```
sudo /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node
```
```
sudo /usr/share/elasticsearch/bin/elasticsearch-reconfigure-node --enrollment-token <enrollment-token>
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
sudo systemctl status elasticsearch.service
```
- If needed you can stop the service
```
sudo systemctl stop elasticsearch.service
```

### Install Kibana
- [DOC Reference](https://www.elastic.co/guide/en/kibana/current/deb.html)

```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```
```
sudo apt-get install apt-transport-https
```
```
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
```
```
sudo apt-get update && sudo apt-get install kibana
```
```
sudo /bin/systemctl daemon-reload
```
```
sudo /bin/systemctl enable kibana.service
```
```
sudo systemctl start kibana.service
```
```
sudo systemctl status kibana.service
```
```
sudo systemctl stop kibana.service
```

### Configure Kibana

- Edit the file kibana.yml
```
sudo vim /etc/kibana/kibana.yml
```
- Change the pfollowing parameters
```
server.port: 5601
server.host: 0.0.0.0
```
```
sudo systemctl stop kibana.service
```
```
sudo systemctl start kibana.service
```
```
sudo systemctl status kibana.service
```

### Ingressar Kibana ao Elastichsearch
- In any Elastichsearch node execute the following command to generate the token
```
sudo /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```
- Copy the token
- Open a web browser and enter the Kibana's IP address with the port 5601
- http://<IP-ADDRESS>:5601/
- Paste the token that you have generated
- The Kibana will ask about the verification code the following command to get the code
```
sudo bash /usr/share/kibana/bin/kibana-verification-code
```

### Install Logstash
- [DOC Reference](https://www.elastic.co/guide/en/logstash/current/installing-logstash.html#installing-binary)

- Pre-requisitos
- Verify Java installation
```
sudo apt update
java -version
```
- Install Java
```
sudo apt install openjdk-17-jre-headless
```
- Verrify Java installation again
```
java -version
```

```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```
```
sudo apt-get install apt-transport-https
```
```
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
```
```
sudo apt-get update && sudo apt-get install logstash
```
```
sudo /bin/systemctl daemon-reload
```
```
sudo /bin/systemctl enable logstash.service
```
```
sudo systemctl start logstash.service
```
```
sudo systemctl status logstash.service
```
```
sudo systemctl stop logstash.service
```

### Reference Links
- [Iniciando com Elastck Stack](https://youtu.be/Bb3g8xk0Cys)
- [Elastic Stack: O mínimo que um desenvolvedor precisa saber](https://youtu.be/VnHV8SUOKz0)
