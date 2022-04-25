# Pré-requisitos
- Ter o Kubectl instalado
- Ter o OCI CLI instalado
- Ter o OKE criado
- Ter o kubeconfig configurado
- exemplo

# Procedimento
## Criar os Namespace no cluster OKE
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
|wpprd|wpprd|
|wphom|wphom|
|wpdev|wpdev|

```
kubectl create namespace wpprd
kubectl create namespace wphom
kubectl create namespace wpdev
```
```
kubectl get ns
```
## Deployment
- Criar e executar os arquivos wordpress-deployment.yaml, mysql-deployment.yaml e kustomization.yaml

- wordpress-deployment.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  ports:
    - port: 80
  selector:
    app: wordpress
    tier: frontend
  type: LoadBalancer
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: wp-pv-claim
  labels:
    app: wordpress
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
      tier: frontend
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: wordpress
        tier: frontend
    spec:
      containers:
      - image: wordpress
        name: wordpress
        env:
        - name: WORDPRESS_DB_HOST
          value: wordpress-mysql
        - name: WORDPRESS_DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-pass
              key: password
        ports:
        - containerPort: 80
          name: wordpress
        volumeMounts:
        - name: wordpress-persistent-storage
          mountPath: /var/www/html
      volumes:
      - name: wordpress-persistent-storage
        persistentVolumeClaim:
          claimName: wp-pv-claim
```
- mysql-deployment.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  ports:
    - port: 3306
  selector:
    app: wordpress
    tier: mysql
  clusterIP: None
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
  labels:
    app: wordpress
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
      tier: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: wordpress
        tier: mysql
    spec:
      containers:
      - image: mysql
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-pass
              key: password
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim
```

- kustomization.yaml
```
secretGenerator:
- name: mysql-pass
  literals:
  - password=adminadmin123!

resources:
  - mysql-deployment.yaml
  - wordpress-deployment.yaml
```


```
kubectl apply -k ./ -n wpprd
kubectl apply -k ./ -n wphom
kubectl apply -k ./ -n wpdev
```

- Verificar a criação dos recursos com o "get"
```
kubectl get deployments -n wpprd
kubectl get pods -n wpprd
kubectl get svc -n wpprd
kubectl get pvc -n wpprd
```
```
kubectl get deployments -n wphom
kubectl get pods -n wphom
kubectl get svc -n wphom
kubectl get pvc -n wphom
```
```
kubectl get deployments -n wpdev
kubectl get pods -n wpdev
kubectl get svc -n wpdev
kubectl get pvc -n wpdev
```

- Verificar a criação dos recursos com o "describe"
```
kubectl descrive <deployments, pods, svc, pvc> <especificar elemento - opcional> -n <namespace>
```

- Copiar o EXTERNAL-IP e testar o acesso no browser de cada site
- Verificar a criação dos recursos no OCI (Reserved Public IP, Load Balancer e Block Volume)

## Instalação NGINX Ingress Controller
- Instalar o ingress-controller no cluster
[NGINX Ingress Controlle](https://kubernetes.github.io/ingress-nginx/deploy/)
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/cloud/deploy.yaml
```

- Vericar a instalação do ingress-controller
```
kubectl get all -n ingress-nginx
```

- Alterar o Size Shape do Load Balancer para 10Mpbs para ficar no Always Free

- Criar e executar os arquivos wpprd-ingress.yaml, wphom-ingress.yaml e wpdev-ingress.yaml

- wpprd-ingress.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wordpress-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt"
spec:
  tls:
  - hosts:
    - "wpprd.mylabdomain.tk"
    secretName: "wpprd-tls"
  rules:
  - host: wpprd.mylabdomain.tk
    http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: wordpress
              port:
                number: 80
```

- wphom-ingress.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wordpress-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt"
spec:
  tls:
  - hosts:
    - "wphom.mylabdomain.tk"
    secretName: "wphom-tls"
  rules:
  - host: wphom.mylabdomain.tk
    http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: wordpress
              port:
                number: 80
```

- wpdev-ingress.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wordpress-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt"
spec:
  tls:
  - hosts:
    - "wpdev.mylabdomain.tk"
    secretName: "wpdev-tls"
  rules:
  - host: wpdev.mylabdomain.tk
    http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: wordpress
              port:
                number: 80
```

```
kubectl apply -f wpprd-ingress.yaml -n wpprd
kubectl apply -f wphom-ingress.yaml -n wphom
kubectl apply -f wpdev-ingress.yaml -n wpdev
```

- Verificar o ingress
```
kubectl get ingress -n wpprd
kubectl get ingress -n wphom
kubectl get ingress -n wpdev
```

- Adicionar a entrada no DNS de acordo com o IP do ingress controller

- Validar o acesso pelo dominio
```
wpprd.mylabdomain.tk
wphom.mylabdomain.tk
wpdev.mylabdomain.tk
```

- Verificar os serviços dos sites
```
kubectl get svc -n wpprd
kubectl get svc -n wphom
kubectl get svc -n wpdev
```

- Alterar o service dos sites para ClusterIP no arquivo wordpress-deployment.yaml
```
  type: ClusterIP
```
- Executar o apply novamente
```
kubectl apply -k ./ -n wordpress01
kubectl apply -k ./ -n wordpress02
```
- Verificar novamente os serviços dos sites
```
kubectl get svc -n wordpress01
kubectl get svc -n wordpress02
```
- Validar o acesso pelo dominio
```
wordpress01.mylabdomain.tk
wordpress02.mylabdomain.tk
```
## Instalação cert-manager
- Instalar o cert-manager
[cert-manager](https://cert-manager.io/docs/installation/)
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml
```
- Criar e executar o arquivo do cluster issuer clusterissuer.yaml
```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: willianpereiraalmeida@hotmail.com
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - http01:
        ingress:
          class: nginx
```
```
kubectl apply -f clusterissuer.yaml
```
- Verificar o cluster issuer que é a nível do cluster
```
kubectl get clusterissuer
```

- Alterar os arquivos wpprd-ingress.yaml, wphom-ingress.yaml e wpdev-ingress.yaml para suportar tls
```
... 
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt"
spec:
  tls:
  - hosts:
    - "wpprd.mylabdomain.tk"
    secretName: "wpprd-tls"
  rules:
...
```
```
...
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt"
spec:
  tls:
  - hosts:
    - "wphom.mylabdomain.tk"
    secretName: "wphom-tls"
  rules:
  ...
```
```
...
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt"
spec:
  tls:
  - hosts:
    - "wpdev.mylabdomain.tk"
    secretName: "wpdev-tls"
  rules:
  ...
```

```
kubectl apply -f wpprd-ingress.yaml -n wpprd
kubectl apply -f wphom-ingress.yaml -n wphom
kubectl apply -f wpdev-ingress.yaml -n wpdev
```

- Verificar os certificados e os secrets
```
kubectl get certificate -n wpprd
kubectl get certificate -n wphom
kubectl get certificate -n wpdev
kubectl get secrets -n wpprd
kubectl get secrets -n wphom
kubectl get secrets -n wpdev
```

- Validar o acesso aos sites

## Instalar o Kubernets Dashboard

- Acessar o o tutorial sobre como instalar o [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)

- Executar o seguinte comando para instalar o Kubernetes Dashboard
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
```

- Criar uma entrada no DNS para o Kubernetes Dashboard apontando para o IP do ingress controller
- Expor o Kubernetes Dashboard no ingress controller com o seguinte template dashboard-ingress.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dashboard-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt"
    nginx.ingress.kubernetes.io/secure-backends: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    ingress.kubernetes.io/backend-protocol: "HTTPS"
    kubernetes.io/tls-acme: "true"
spec:
  tls:
  - hosts:
    - "dashboard.mylabdomain.tk"
    secretName: "dashboard-tls"
  spec:
  defaultBackend:
    service:
      name: kubernetes-dashboard
      port:
        number: 443
  rules:
  - host: dashboard.mylabdomain.tk
    http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: kubernetes-dashboard
              port:
                number: 443
```

- Acessar a Dashboard pelo nome que foi criado no DNS 

- Criar acesso RBAC no seu [Kubernetes Dashboard](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md) através do arquivo dashboard-adminuser.yaml o qual contém as seguintes linhas
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
  ```

- Executar o comando
```
kubectl apply -f dashboard-adminuser.yaml
```

-
- Executar o comando para obter o token
```
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```

## Install Helm

- Install Helm on Ubuntu from tutorial on [Helm site](https://helm.sh/docs/intro/install/)

```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

- Testar a instalação do Helm

```
helm list
```

- Quick Start with [Repo Bitnami](https://helm.sh/docs/intro/quickstart/)

## Install Prometheus

- From helm with this [tutorial](https://artifacthub.io/packages/helm/prometheus-community/prometheus#configuration)


## Troubleshooting

```
kubectl port-forward <pod-name> 8081:80 -n <namespace>
```
```
kubectl exec -it -n <namespace> <pod-name> /bin/bash
```
```
mysql -u root -p
adminadmin123!
```
```
show databases;
```

