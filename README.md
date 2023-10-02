

##Terraform

Tasks:
 - Create Security Group in default VPC.
 - Create ssh key (for Ansible)
 - Run EC2 t2.micro instance with added ssh key
 - Add "A" record to Cloudflare (DNS) with IP of the server
 - Create inventory.ini file for Ansible





####Requirements:

```
- Configured Authentication with AWS (aws configure)
- Terraform 0.13 and later
- Cloudflare API token stored in AWS Secret Manager
- Ansible 2.9 and later
```



####How to run:

```
terraform init
terraform apply

````



