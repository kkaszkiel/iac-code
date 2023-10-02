terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

  }
}


# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}


# Configure Cloudflare Provider

provider "cloudflare" {
  api_token = local.iac_credentials.CF_API_TOKEN
}






### AWS

data "aws_secretsmanager_secret_version" "credentials" {
    secret_id = var.secret_name
}


# Get decrypted key from AWS Secret manager
locals {
    iac_credentials = jsondecode(
        data.aws_secretsmanager_secret_version.credentials.secret_string
    )
}


resource "aws_security_group" "MyStaticWebsiteSG" {
  name = "MyStaticWebsiteSG"

    // Allow SSH
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

    // HTTP
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

    // HTTPS
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

    // Outbound traffic
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


#Create EC2
resource "aws_instance" "WebServer" {
  ami = var.ami
  instance_type = var.instance_type
  security_groups = ["MyStaticWebsiteSG"]
  associate_public_ip_address = true
  key_name = aws_key_pair.aws_key.key_name

  tags = {
    Name = var.instance_tag
  }

}

# SSH key for Ansible

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "aws_key" {
  key_name = "ansible-ssh-key"
  public_key = tls_private_key.key.public_key_openssh
}


### Cloudflare

data "cloudflare_zone" "this" {
  name = var.domain_name
}

resource "cloudflare_record" "www" {
  name    = "@"
  type    = "A"
  ttl     = 1
  proxied = false
  value   = aws_instance.WebServer.public_ip
  zone_id = data.cloudflare_zone.this.id
}

