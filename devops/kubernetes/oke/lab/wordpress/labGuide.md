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
|Site1|Site1|
|Site2|Site2|