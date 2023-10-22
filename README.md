## Terraform

Tasks:
 - Create Security Group in default VPC.
 - Create ssh key (for Ansible)
 - Run EC2 t2.micro instance with added ssh key
 - Add "A" record to Cloudflare (DNS) with IP of the server
 - Create inventory.ini file for Ansible



## Ansible

Tasks:
 - Install nginx and cronie (crontab)
 - Create nginx config for domain_name (variables.tf)
 - Get a TLS certificate from Let’s Encrypt using acme.sh (Certificate renews automatically using a task in crontab)
 - Deploy static website from git repository to EC2. You can define the repository name in the variables.tf file.



### Requirements:

```
- Configured Authentication with AWS (aws configure)
- Terraform 0.13 and later
- Cloudflare API token stored in AWS Secret Manager (Secret key = CF_API_TOKEN)
- Ansible 2.9 and later
- Define your variables, e.g. ec2 instance type, domain name... in variables.tf
```



### How to run:

```
terraform init
terraform apply

cd ansible && ansible-playbook playbook.yaml

```



### Notice:

When you run the Ansible playbook for the first time, all tasks are executed.
The second time you run it, **only the deploy-page task will run.** (You can use Ansible later just to deploy new versions of the site)