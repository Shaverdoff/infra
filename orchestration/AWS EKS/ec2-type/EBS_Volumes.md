
# PERSISTENT VOLUMES
## EBS
```
# https://aws.amazon.com/premiumsupport/knowledge-center/eks-persistent-storage/
export env=dev 
export cluster_name=api-$env
export KUBECONFIG=/opt/.kube/configs/$env.yml
```
## 1. Create an IAM policy that allows the CSI driver's service account to make calls to AWS APIs:
```
export EBS_CSI_POLICY_NAME="Amazon_EBS_CSI_Driver-$env" cluster_name="api-$env" region="us-east-2" iamserviceaccount="ebs-csi-controller-sa-$env"
# Create an IAM policy called Amazon_EBS_CSI_Driver:
curl -o example-iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json

aws iam create-policy \
  --region $region \
  --policy-name $EBS_CSI_POLICY_NAME \
  --policy-document file://example-iam-policy.json
# View your cluster's OIDC provider URL:
aws eks describe-cluster --name $cluster_name --region=$region --query "cluster.identity.oidc.issuer" --output text
# export the policy ARN as a variable
export EBS_CSI_POLICY_ARN=$(aws --region $region iam list-policies --query 'Policies[?PolicyName==`'$EBS_CSI_POLICY_NAME'`].Arn' --output text)
echo $EBS_CSI_POLICY_ARN
# Мы попросим eksctl создать роль IAM, содержащую только что созданную политику IAM, и связать ее с вызываемой учетной записью службы Kubernetes, $iamserviceaccount которая будет использоваться драйвером CSI:
# Create an IAM OIDC provider for your cluster
eksctl utils associate-iam-oidc-provider \
  --region=$region \
  --cluster=$cluster_name \
  --approve
# Create a service account
eksctl delete iamserviceaccount --region=$region --cluster $cluster_name --namespace kube-system --name $iamserviceaccount
eksctl create iamserviceaccount \
  --region=$region \
  --cluster $cluster_name \
  --name $iamserviceaccount \
  --namespace kube-system \
  --attach-policy-arn $EBS_CSI_POLICY_ARN \
  --override-existing-serviceaccounts \
  --approve
eksctl get iamserviceaccount --region=$region --cluster=$cluster_name --namespace kube-system
# SAVE USER-CREDS IN SECRET
curl https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/deploy/kubernetes/secret.yaml > secret.yaml
# create user with programmic access, attach created policy to him and paste ACCESS KEY IS and SECRET KEY TO secret.yaml
# Edit the secret with user credentials
nano secret.yaml
kubectl apply -f secret.yaml

# Deploy Amazon EBS CSI driver with helm
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm search repo aws-ebs-csi-driver
# uninstall 
helm delete aws-ebs-csi-driver --namespace kube-system
# install
helm upgrade -i aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver \
  -n kube-system \
  --set controller.region=$region \
  --set controller.serviceAccount.create=false \
  --set controller.serviceAccount.name=$iamserviceaccount \
  --set controller.extra-tags.ekscluster=$cluster_name \
  --set node.serviceAccount.create=false \
  --set node.serviceAccount.name=$iamserviceaccount
 
# NOTE: NEED TO CREATE STORAGE CLASS or use with values.yaml
Dynamic Volume Provisioning allows storage volumes to be created on-demand.
# ===========================================================
# STORAGE CLASS
# ===========================================================
cat << EoF > storageclass.yaml
---
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: ebs-sc
  labels:
    cluster: $env
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: ebs.csi.aws.com # Amazon EBS CSI driver
parameters:
  type: gp2
  fstype: xfs
  encrypted: 'true' # EBS volumes will always be encrypted by default
# for prod set - Retain
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
#mountOptions:
#- debug
EoF
# CHECK
kubectl -n kube-system rollout status deployment ebs-csi-controller
# check
kubectl get pod -n kube-system -l "app.kubernetes.io/name=aws-ebs-csi-driver,app.kubernetes.io/instance=aws-ebs-csi-driver"
kubectl delete -f storageclass.yaml
kubectl apply -f storageclass.yaml



# OTHER METHOD, get values.yaml with all config and use it
# install (VALUES.yaml with predefined storage class)
helm upgrade --install aws-ebs-csi-driver --namespace kube-system -f values_$env.yaml   aws-ebs-csi-driver/aws-ebs-csi-driver
# ERROR
GRPC error: rpc error: code = Internal desc = Could not create volume "pvc-3004330d-d646-4161-9c84-8af432ece0a3": could not create volume in EC2: 
UnauthorizedOperation: You are not authorized to perform this operation. Encoded authorization failure message: 
## MAYBE YOU FORGOT TO CREATE USER! in secret.yaml

```
