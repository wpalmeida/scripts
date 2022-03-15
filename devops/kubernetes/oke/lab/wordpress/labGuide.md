# Pré-requisitos
- Ter o Kubectl instalado
- Ter o OCI CLI instalado
- Ter o OKE criado
- Ter o kubeconfig configurado

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
      - image: wordpress:4.8-apache
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
      - image: mysql:5.6
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

- wordpress01-ingress.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wordpress-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: wordpress01.mylabdomain.tk
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

- wordpress01-ingress.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wordpress-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: wordpress02.mylabdomain.tk
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

