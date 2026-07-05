# Zomato CodeBuild

This folder contains Terraform to create an AWS CodeBuild project named `Zomato-CI`.

## Important note about GitHub source

CodeBuild with GitHub source requires an AWS CodeConnections connection to your GitHub account.
That connection must be created in the AWS console once, then referenced by the project.

## Manual steps required

1. Open the AWS Console.
2. Go to Developer Tools -> CodeConnections.
3. Create a connection for GitHub.
4. Choose GitHub and authorize AWS to access your GitHub account.
5. After the connection is created, copy the connection ARN.
6. Update the Terraform to use that ARN or create the project manually in the console.
```bash
variable "code_connection_arn" {
  description = "ARN of the AWS CodeConnections connection for GitHub"
  type        = string
  default     = "arn:aws:codeconnections:us-east-1:652978908369:connection/b9f56633-9327-435c-b7c6-254572966bda"
}
```

## Terraform usage

```bash
cd /Users/apple/Projects/aws-eks-microservices-deployment/08_zomato_codebuild
terraform init
terraform apply -var='github_repo=<your-repo-name>'
```
