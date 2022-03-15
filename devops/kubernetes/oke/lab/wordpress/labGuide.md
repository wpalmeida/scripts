# Pré-requisitos
- Ter instalado o Kubectl
- Ter instalado o OCI CLI

# Procedimento
- Criar os Namespace no cluster OKE
```
kubectl create namespace <NAME>
```
- Verificar a criação dos namespace
```
kubectl get ns
```
- Criar os seguintes namespace

|Name|Descrição|
|--|--|
|wordpress01|wordpress01|
|wordpress02|wordpress02|

```
kubectl create namespace wordpress01
kubectl create namespace wordpress01
```
```
kubectl get ns
```

- Criar e executar os arquivos kustomization.yaml, wordpress-deployment.yaml e mysql-deployment.yaml

```
kubectl apply -k ./ -n wordpress01
kubectl apply -k ./ -n wordpress02
```

- Verificar a criação dos recursos com o "get"
```
kubectl get deployments -n wordpress01
kubectl get pods -n wordpress01
kubectl get svc -n wordpress01
kubectl get pvc -n wordpress01
```
```
kubectl get deployments -n wordpress02
kubectl get pods -n wordpress02
kubectl get svc -n wordpress02
kubectl get pvc -n wordpress02
```

- Verificar a criação dos recursos com o "describe"
```
kubectl descrive <deployments, pods, svc, pvc> <especificar elemento - opcional> -n <namespace>
```

- Copiar o EXTERNAL-IP e testar o acesso no browser de cada site
- Verificar a criação dos recursos no OCI (Reserved Public IP, Load Balancer e Block Volume)

- Instalar o ingress-controller no cluster
[NGINX Ingress Controlle](https://kubernetes.github.io/ingress-nginx/deploy/)
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/cloud/deploy.yaml
```

- Vericar a instalação do ingress-controller
```
kubectl get all -n ingress-nginx
```

- Criar e executar os arquivos wordpress01-ingress.yaml e wordpress01-ingress.yaml
```
kubectl apply -f wordpress01-ingress.yaml -n wordpress01
kubectl apply -f wordpress02-ingress.yaml -n wordpress02
```

- Verificar o ingress
```
kubectl get ingress -n wordpress01
kubectl get ingress -n wordpress02
```

- Adicionar a entrada no DNS de acordo com o IP do ingress controller

- Validar o acesso pelo dominio

