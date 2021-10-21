### HOW USE IT:
```
# create new workspace
terraform workspace new node
terraform workspace new master
# list workspaces
terraform workspace list
# select node
terraform workspace select node 
# apply with var-file
terraform apply -var-file=node.tfvars
```
