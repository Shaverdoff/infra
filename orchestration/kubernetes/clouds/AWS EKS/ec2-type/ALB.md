!!!! ALB v2.2 !!!!
# STEP 1: Create & Associate IAM OIDC Provider for our EKS Cluster
#### Step 1.1: Create an IAM policy for the service account 
**Note:** The ALB Ingress Controller requires several API calls to provision the ALB components for the ingress resource type. 
#### verify
```
export env=prod
export region=us-east-2 cluster_name=api-$env KUBECONFIG=/opt/.kube/configs/$env.yml
aws eks describe-cluster --region $region --name $cluster_name --query "cluster.identity.oidc.issuer" --output text
```
Пример вывода:
```
https://oidc.eks.us-west-2.amazonaws.com/id/EXAMPLED539D4633E53DE1B716D3041E
```
Так же можно проверить его тут:    
https://console.aws.amazon.com/iamv2/home?#/identity_providers
Перечислите поставщиков IAM  OIDC в своей учетной записи. Заменить <EXAMPLED539D4633E53DE1B716D3041E>(включая <>) значением, возвращенным предыдущей командой.
```
aws iam list-open-id-connect-providers | grep <EXAMPLED539D4633E53DE1B716D3041E>
```
Если результат возвращается предыдущей командой, значит, у вас уже есть провайдер для вашего кластера - **GO TO THE STEP 04**. Если выходные данные не возвращаются, необходимо создать поставщика IAM  OIDC.
Create an IAM OIDC identity provider for your cluster:
```
eksctl utils associate-iam-oidc-provider --region $region --cluster $cluster_name --approve
#### verify
aws iam list-open-id-connect-providers | grep <EXAMPLED539D4633E53DE1B716D3041E>
``` 
# STEP 04:  IAM policy for the AWS Load Balancer Controller
```
curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/install/iam_policy.json
```
```
# Create IAM POLICY with name - AWSLoadBalancerControllerIAMPolicy
# DELETE OLD POLICY!
aws iam create-policy \
--region=$region \
--policy-name AWSLoadBalancerControllerIAMPolicy-$env \
--policy-document file://iam_policy.json
```
# STEP 05:  Create a IAM role and ServiceAccount for the Load Balancer controller, use the ARN from the step above
```
## Create a IAM role and ServiceAccount for the Load Balancer controller, use the ARN from the step above
### for delete iamserviceaccount
eksctl delete iamserviceaccount --cluster=$cluster_name --region=$region --namespace=kube-system --name=aws-load-balancer-controller-$env

export ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AWSLoadBalancerControllerIAMPolicy-'$env'`].Arn' --output text)
echo $ARN
eksctl create iamserviceaccount \
  --cluster=$cluster_name \
  --region=$region \
  --namespace=kube-system \
  --name=aws-load-balancer-controller-$env \
  --attach-policy-arn=$ARN \
  --override-existing-serviceaccounts \
  --tags "cluster=$cluster_name" \
  --approve
```
####  To verify that the new service role was created, run the following command:
```
eksctl get iamserviceaccount --region=$region --cluster=$cluster_name --namespace kube-system
```
# Step-06: Install aws-load-balancer-controller
```
#Add the EKS repository to Helm:
helm repo add eks https://aws.github.io/eks-charts
helm repo update
#Install the TargetGroupBinding CRDs:
#kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

# Install the AWS Load Balancer controller, if using iamserviceaccount
export vpc=$(aws eks describe-cluster --region $region --name $cluster_name --query "cluster.resourcesVpcConfig.vpcId" --output text)
echo $vpc
helm delete aws-load-balancer-controller -n kube-system
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
--set clusterName=$cluster_name \
--set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller-$env \
--set vpcId=$vpc \
--set region=$region \
--set replicaCount=1

# Additional options
https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller
```
**To check the status of the  **alb-ingress-controller**  deployment, run the following command:**
```
kubectl -n kube-system get pod
kubectl logs -f --tail 200 -n kube-system $(kubectl get po -n kube-system | egrep -o 'aws-load-balancer-controller[a-zA-Z0-9-]+')
```
#### EXAMPLE for check AWS-LB-controller
nano 2048.yml
```
---
apiVersion: v1
kind: Namespace
metadata:
  name: game-2048
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: game-2048
  name: deployment-2048
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: app-2048
  replicas: 5
  template:
    metadata:
      labels:
        app.kubernetes.io/name: app-2048
    spec:
      containers:
      - image: alexwhen/docker-2048
        imagePullPolicy: Always
        name: app-2048
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  namespace: game-2048
  name: service-2048
spec:
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
  type: NodePort
  selector:
    app.kubernetes.io/name: app-2048
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: game-2048
  name: ingress-2048
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
  - http:
      paths:
      - path: /*
        pathType: ImplementationSpecific
        backend:
          service:
            name: service-2048
            port: 
              number: 80
```
```
kubectl apply -f 2048.yml
kubectl get pods -n game-2048
kubectl get ingress -n game-2048
```
##### copy ADDRESS and paste to Browser

## ERRORS
```
{"level":"error","ts":1626447030.228887,"logger":"controller","msg":"Reconciler error","controller":"ingress","name":"kubernetes-dashboard","namespace":"kubernetes-dashboard","error":"couldn't auto-discover subnets: UnauthorizedOperation: You are not authorized to perform this operation.\n\tstatus code: 403, request id: addb4e72-462e-4bff-aabf-0ebab2f407b1"}
# Check correct CLUSTER-NAME
kubectl get deployment -n kube-system aws-load-balancer-controller -oyaml |grep "cluster-name"
# !!!  
# in mycase my policy json was 2.1.3 and i install controller v2.2.0
  ```
