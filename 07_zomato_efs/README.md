# Zomato EFS Terraform

This project creates an Amazon EFS filesystem for the Zomato VPC.

## How it works

The configuration will:
- look for an existing VPC named `zomato-vpc`
- use the private subnets from that VPC for EFS mount targets
- create an EFS file system with the identifier `zomato`
- mount it at `/efs` using the NFS client

## Apply

```bash
cd /Users/apple/Projects/aws-eks-microservices-deployment/07_zomato_efs
tf init
tf apply
```

If you want to override the VPC explicitly:

```bash
tf apply -var='vpc_id=vpc-xxxxxxxx'
```
