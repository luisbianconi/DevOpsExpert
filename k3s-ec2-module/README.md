# Terraform Module: EC2 with K3s and Nginx

This module creates an EC2 instance on AWS, installs K3s Kubernetes and deploys a sample Nginx server.

## Usage

```
module "k3s_ec2" {
  source = "./k3s-ec2-module"

  region        = "us-east-1"
  instance_type = "t3.small"
}
```

After `terraform apply` the public IP of the instance is output. You can access Nginx using that IP on port 80.
