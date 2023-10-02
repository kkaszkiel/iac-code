
###AWS

# Amazon Linux OS
variable "ami" {
  type = string
  default = "ami-08f32efd140b7d89f"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "instance_tag" {
  type = string
  default = "MyStaticWebsite"
}
#Secret name from AWS Secret Manager
variable "secret_name" {
  type = string
  default = "MyStaticWebsiteSecrets"
}





###Cloudflare

variable "domain_name" {
  type = string
  default = "kkaszkiel.pl"
}