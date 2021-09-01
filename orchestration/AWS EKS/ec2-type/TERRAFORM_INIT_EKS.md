# DELETING OLD CLUSTER
```
1 delete old ELB
2 second delete vpc
```

# Step-00 Update the repo
```
# here you can check last tag - https://github.com/terraform-aws-modules/terraform-aws-eks
export tag="v17.1.0"
mv terraform-aws-eks terraform-aws-eks-old
git clone https://github.com/terraform-aws-modules/terraform-aws-eks.git --branch $tag --single-branch
nano eks_node.tf
# change path to terraform repo
terraform init

# HOW USE IT:
terraform workspace list
export env=stg
terraform workspace select $env
terraform apply -var-file=$env.tfvars

# FOR DEV
terraform workspace select default
terraform apply -var-file=dev.tfvars
```

# Step-01: install eksctl
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/bin
eksctl version
```
# Step-02: Create Cluster
```
edit terraform.tfvars
terraform init
terraform apply
```
#### Get List of clusters
```
export region=us-east-2 cluster_name=api-dev
eksctl --region us-east-2 get clusters 
```
#### KubeConfig
```
export env=dev
export cluster_name=api-$env
aws eks --region $region update-kubeconfig --name $cluster_name
cp /root/.kube/configs/kubeconfig.yml /opt/.kube/configs/test.yml
export KUBECONFIG=$KUBECONFIG:/opt/.kube/configs/test.yml
kubectl get svc
```
#### delete cluster
```
terraform destroy
```
