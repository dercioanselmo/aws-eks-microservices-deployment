# Multi-Account, Multi-Region EC2 Deployment with Terraform

This project provisions Ubuntu EC2 instances in multiple AWS accounts and regions using a single Terraform root configuration. It is designed for scenarios where you want to deploy the same infrastructure pattern to different accounts (for example, development and production) without duplicating the full Terraform code.

## What this project does

The configuration:

- creates two AWS provider configurations, one for each deployment target
- deploys EC2 instances into the default VPC of each target account/region
- uses a reusable Terraform module so the same code can be applied repeatedly
- opens the required Kubernetes-related ports and SSH access through a security group
- uses an S3 backend for Terraform state storage

## Architecture overview

The folder structure is organized as follows:

- [c1-versions.tf](c1-versions.tf) – Terraform version, providers, and AWS provider configuration
- [c2-variables.tf](c2-variables.tf) – input variables for both deployment targets
- [c3-security-group.tf](c3-security-group.tf) – module invocation for the first deployment target
- [c4-ec2.tf](c4-ec2.tf) – module invocation for the second deployment target
- [c5-outputs.tf](c5-outputs.tf) – outputs showing instance public/private IPs
- [terraform.tfvars](terraform.tfvars) – values you must customize for your environment
- [modules/ec2_multi_region](modules/ec2_multi_region) – reusable module that creates the EC2 instance and security group

## Prerequisites

Before running this project, make sure you have:

1. Terraform installed
   - Download from: https://developer.hashicorp.com/terraform/downloads
   - Verify with:
     ```bash
     terraform version
     ```

2. AWS CLI installed and configured
   - Install from: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
   - Configure profiles for each account:
     ```bash
     aws configure --profile default
     ```
   - If you use different profiles for different accounts, update the values in [terraform.tfvars](terraform.tfvars)

3. SSH key pairs created in each target region
   - Each region/account combination needs a key pair available in AWS EC2.
   - The key name must match the value you place in the corresponding variable.

4. S3 backend access
   - The backend is currently configured in [c1-versions.tf](c1-versions.tf) to use an S3 bucket named `tfstate-dev-us-east-1-1v8wcs` in `us-east-1`.
   - If your bucket name or region differs, update that block before running Terraform.

## Where to insert your AWS account and deployment parameters

All deployment-specific values are stored in [terraform.tfvars](terraform.tfvars).

You should edit the following sections:

### 1. First deployment target (account A)

These variables control the first deployment target:

- `account_a_name` – logical label for the target
- `account_a_region` – AWS region for target A
- `account_a_profile` – AWS CLI profile used for target A
- `account_a_key_name` – EC2 key pair name for target A
- `account_a_instance_type` – EC2 instance size
- `account_a_root_volume_size` – root disk size in GB
- `account_a_instance_names` – names of the instances created for this target
- `account_a_ssh_cidr_blocks` – CIDR range allowed to SSH into the instance

### 2. Second deployment target (account B)

These variables control the second deployment target:

- `account_b_name`
- `account_b_region`
- `account_b_profile`
- `account_b_key_name`
- `account_b_instance_type`
- `account_b_root_volume_size`
- `account_b_instance_names`
- `account_b_ssh_cidr_blocks`

### 3. Common tags

The `common_tags` map is applied to all created resources and can be customized as needed.

## Example values to replace

The file currently contains placeholders such as:

```hcl
account_a_key_name = "your-key-name-us-east-1"
account_b_key_name = "your-key-name-eu-west-1"
```

Replace these with the actual key pair names that exist in your AWS accounts.

Example:

```hcl
account_a_key_name = "dev-ec2-key"
account_b_key_name = "prod-ec2-key"
```

If your AWS profiles differ, update:

```hcl
account_a_profile = "dev-account"
account_b_profile = "prod-account"
```

## How the deployment works

The root Terraform configuration defines two provider blocks:

- provider alias `account_a`
- provider alias `account_b`

Each provider uses its own AWS region and CLI profile. The module is then instantiated twice, once per provider, so Terraform creates resources independently in both targets.

The reusable module:

- reads the default VPC
- finds a suitable Ubuntu AMI
- creates a security group
- opens SSH and Kubernetes-related ingress rules
- creates one or more EC2 instances

## How to run it

From the project folder:

```bash
cd /Users/apple/Projects/aws-eks-microservices-deployment/09_EC2_Basic_multiple_accounts_regions
```

### 1. Initialize Terraform

```bash
terraform init
```

If the backend configuration changed or you want to force reconfiguration:

```bash
terraform init -reconfigure
```

### 2. Review the planned changes

```bash
terraform plan -var-file=terraform.tfvars -input=false
```

This shows the resources that will be created in both AWS accounts/regions.

### 3. Apply the deployment

```bash
terraform apply -var-file=terraform.tfvars -auto-approve
```

### 4. Destroy the deployment when needed

```bash
terraform destroy -var-file=terraform.tfvars -auto-approve
```

## Important notes

- The current setup assumes that each target account has a default VPC available.
- The module chooses the first public subnet in the default VPC.
- The security group allows SSH from the CIDR you specify in `account_a_ssh_cidr_blocks` and `account_b_ssh_cidr_blocks`.
- For production use, it is strongly recommended to restrict SSH access to a known IP range instead of `0.0.0.0/0`.

## Output values

After apply, Terraform will output the public and private IPs for the instances. These can be used to connect to the machines with SSH.

Example SSH command:

```bash
ssh -i /path/to/your-key.pem ubuntu@<PUBLIC_IP>
```

## Recommended production hardening

Before using this in production, consider:

- replacing `0.0.0.0/0` SSH access with your office or VPN IP range
- enabling IMDSv2 only
- using IAM roles instead of long-lived access keys where possible
- using a more restrictive S3 backend configuration

## Troubleshooting

### Terraform complains about backend initialization

Run:

```bash
terraform init -reconfigure
```

### AWS credentials are not found

Make sure your profiles exist and are configured:

```bash
aws configure --profile <your-profile-name>
```

### Key pair not found

Ensure the EC2 key pair exists in the target AWS region and the key name matches the value in [terraform.tfvars](terraform.tfvars).

## Summary

This project demonstrates a clean way to deploy the same EC2-based infrastructure to multiple AWS accounts and regions from one Terraform codebase. The main customization points are the account-specific variables in [terraform.tfvars](terraform.tfvars), especially the AWS profile, region, and EC2 key pair values.
