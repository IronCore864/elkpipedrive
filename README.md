# Pipedrive Infra Task

## 0. A Brief Overview of the Architecture

Networking:

- AWS VPC
- single region
- multi-AZ (3AZ) HA setup
- redundancy for public subnets
- redundancy for private subnets
- redundancy for NAT gateway

Compute:

- Kubernetes in AWS
- EKS 1.19
- Nodes in private subnet only, no ingress internet access by default
- 2 x m5.xlarge EC2, managed node group with latest AMI

ELK:

- single pod elasticsearch to save resources
- single pod kibana/logstash
- TLS/SSL set up with testing certificates, **NOT production ready** 

Monitoring:

- prometheus stack
- including grafana
- alertmanager

## 1. Local Dependencies

- Docker: for generating testing certificates for ELK.
- Terraform 0.14.7; verisons lower than this is not tested.

## 2. Setup - Networking and Compute

```
cd terraform
terraform init
terraform plan
terraform apply
```

Details see comments in the code, variables, and the readme in each module.

## 3. Setup - ELK and Monitoring

### 3.1 ELK Prerequisites: Certificates Creation

Tool used: ELK official helper. Code and how to use the tool is **NOT** included because I don't want to copy-paste publicly available resources.

For code and doc, see the official repo [here](https://github.com/elastic/helm-charts/blob/master/elasticsearch/examples/security/Makefile#L21). 

Basically, a docker container is used to generate the certificates and create k8s secret from them.

### 3.2 ELK

```
cd elk
kubectl create ns elk
helm repo add elastic https://helm.elastic.co
helm install elasticsearch -n elk elastic/elasticsearch -f es.yaml
helm install logstash -n elk  elastic/logstash -f logstash.yaml
helm install kibana -n elk  elastic/kibana -f kibana.yaml
```

### 3.3 Prometheus

```
kubectl create ns monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install promestack -n monitoring prometheus-community/kube-prometheus-stack
```

## 4 Notes

### 4.1 Manual Steps

The helm charts are installed manually.

In reality, it could be done automatically by GitOps, including certificates.

I did not include GitOps as part of the solution due to time issue.

For GitOps, see my medium article [here](https://medium.com/4th-coffee/argo-cd-up-and-running-in-kubernetes-2d8fc5086464), and my examples [here](https://github.com/IronCore864/gitops-argocd), and my personal argocd setup [here](http://argocd.guotiexin.com/) (you can't login though.)

### 4.2 Monitoring

CPU/Disk monitoring is provided by the default prometheus stack dashboards.

### 4.3 Backup Approach

The networking/compute part is HA setup, without any need for backup.

For ELK, there are two EBS volumes which can be either backed up to S3 as a snapshot, or as a cross-region backup. EFS can be used for HA setup without any need to backup too (at higher cost).

### 4.4 TLS

Done by self-signed certs; for production, see [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html#node-certificates).

### 4.5 What's NOT Implemented

All the requirements including bonus tasks are included with one exception: Kibana doesn't listen on a public interface, because I do not want to create a public ingress in my testing environment.

For exposing a service in k8s running in a private subnet, an ingress controller is required, and tagging the public subnets is also required so that the ingress controller can find the corresponding subnets.

For more details on running AWS Load Balancer Controller, see my medium article [here](https://medium.com/devops-dudes/running-the-latest-aws-load-balancer-controller-in-your-aws-eks-cluster-9d59cdc1db98), installation doc [here](https://github.com/IronCore864/guotiexin.com/tree/master/step-3-external-dns-ingress-controller), and usage example [here](https://github.com/IronCore864/guotiexin.com/blob/master/others/argocd-ingress.yaml).
