# Retail Store Microservices Production Deployment

This project provisions a production-grade microservices platform for a retail store system, engineered on AWS using Terraform-based Infrastructure as Code (IaC) with a remote state backend in Amazon S3. The platform is designed to meet real-world requirements for scalability, high availability, security, and continuous delivery.
The infrastructure is built on a multi-AZ VPC architecture, with segregated public and private subnets to ensure secure and resilient communication across services. The core compute layer is powered by Amazon EKS (Elastic Kubernetes Service), provisioned with a highly available node distribution across Availability Zones to support fault tolerance and workload isolation.

A full DevOps lifecycle is implemented, combining CI/CD pipelines with GitHub Actions and GitOps-driven deployments through ArgoCD and Argo Rollouts, enabling controlled, progressive delivery strategies. Container images are managed in Amazon ECR, ensuring secure and efficient artifact storage and distribution.

The Kubernetes environment is extended with critical components such as Karpenter for dynamic node scaling, Horizontal Pod Autoscaling (HPA) for workload elasticity, and ExternalDNS integrated with Amazon Route 53 for automated service discovery. Secure configuration and secret handling are managed through AWS Secrets Manager and fine-grained IAM roles and policies.

The platform integrates multiple AWS managed services to support application functionality, including Amazon RDS (MySQL and PostgreSQL) for relational data, Amazon DynamoDB for NoSQL workloads, Amazon ElastiCache for caching, and Amazon SQS for asynchronous messaging and decoupled service communication.

End-to-end observability is achieved using AWS Distro for OpenTelemetry, Amazon CloudWatch, and Amazon Managed Prometheus and Grafana, providing comprehensive monitoring, logging, and tracing across the system.

This implementation reflects a fully automated, resilient, and scalable cloud-native architecture, aligned with enterprise-grade DevOps and platform engineering practices.

---

## Implementation
### Pre-requisites
#### Install and configure the admin environment
 - AWS Credentials using Console - IAM
   - Create a machine User if not exists
   - Generate Access Key, selecting CLI option
   - Save Access Key ID and Secret Access Key
 - Terraform CLI
 - AWS CLI
 - VS Code and Terraform Extension

### Terraform Remote State File
The Terraform State files of all project is managed remotely in an S3 Bucket provisioned using the ***01_remote_backend_s3bucket*** terraform code.
Execute the terraform init, validate, plan, and apply -auto-approve. Wait for the Output, and copy the bucket ID just provisioned. This ID will be used throughout the Terraform project components.
```bash
TODO: Show the VPC output lines of Remote state file used in the next deployment
```
### Retail Store Microservices Application Stack
![Retail Store Microservices Application Stack](images/02_retail_application.png)

Microservices-based retail web platform deployed on Amazon EKS, composed of independently scalable and loosely coupled services.
#### Microservices Layer
 - **Catalog Service** — Golang-based microservice responsible for product catalog management and inventory retrieval.
 - **Cart Service** — Java Spring Boot service handling shopping cart state management and session operations.
 - **Checkout Service** — Node.js microservice responsible for order processing and transaction orchestration.
 - **Orders Service** — Java Spring Boot service managing order lifecycle, persistence, and order state transitions.
 - **UI Service** — Java Spring Boot frontend application serving the customer-facing retail interface.
#### Data Layer
 - **Amazon RDS MySQL** — Relational database supporting transactional application workloads.
 - **Amazon RDS PostgreSQL** — Relational database used for service-specific persistent storage requirements.
 - **Amazon DynamoDB** — Fully managed NoSQL database supporting high-scale low-latency key-value access patterns.
#### Caching Layer
 - **Amazon ElastiCache Redis** — In-memory distributed caching layer used for low-latency data access, session acceleration, and performance optimization.
#### Messaging Layer
 - **Amazon SQS** — Managed asynchronous messaging service enabling decoupled inter-service communication and event-driven workload processing.
### VPC
![Retail Store Microservices Application Stack](images/03_VPC.png)

The platform network layer is built within a dedicated AWS VPC using the CIDR block 10.0.0.0/16. The VPC is distributed across three Availability Zones to ensure high availability, fault tolerance, and resilient service communication.
The network topology comprises:
 - 3 Public Subnets distributed across 3 AZs 
 - 3 Private Subnets distributed across 3 AZs 
 - 1 Internet Gateway
 - 3 NAT Gateway
 - Dedicated public and private route tables 

The terraform project source code that defines VPC have the following structure:
| File | Description |
|------|-------------|
| `c1_versions.tf` | Defines Terraform CLI/provider version constraints and configures the remote S3 backend for centralized state management, encryption, and state locking. Initializes the AWS provider configuration for infrastructure provisioning |
| `c2_variables.tf` | Declares root module input variables including AWS region, VPC CIDR range, subnet sizing, environment naming, and global tagging strategy. Centralizes reusable deployment parameters |
| `c3-vpc.tf` | Instantiates the reusable VPC module and injects environment-specific variables into the module abstraction layer |
| `c4-outputs.tf` | Exports critical networking resources including VPC ID and subnet IDs for downstream infrastructure dependencies such as EKS, Load Balancers, and database services |
| `modules/` | Implements a modular Terraform architecture to encapsulate reusable infrastructure components, improve code maintainability, simplify environment replication, and enforce separation of concerns. |
| `modules/vpc/datasources-and-locals.tf` | Retrieves dynamic AWS Availability Zone metadata and computes deterministic subnet CIDR allocations using Terraform local values and cidrsubnet() functions. |
| `modules/vpc/main.tf` | Implements the complete VPC network stack including VPC, subnets, Internet Gateway, NAT Gateways, route tables, and subnet associations across multiple Availability Zones. |
| `modules/vpc/outputs.tf` | Exports internal VPC module resources to the root module, enabling cross-module resource referencing and dependency injection for higher-level infrastructure components. |
| `modules/vpc/variables.tf` | Defines module-scoped input variables to parameterize VPC deployment behavior, enabling reusable and environment-agnostic infrastructure provisioning. |
| `terraform.tfvars` | Provides environment-specific runtime values for Terraform variables including AWS region, CIDR ranges, subnet sizing, environment naming, and tagging metadata. |

### EKS Cluster
![EKS Cluster](images/04_EKS.png)

The diagram above illustrates the high-level architecture and operational components of the Amazon EKS platform provisioned through Terraform. The environment consists of an AWS-managed Kubernetes control plane distributed across multiple Availability Zones, initially backed by three EC2 On-Demand worker nodes forming the primary compute layer for containerized workloads.
The Terraform project responsible for provisioning and configuring the platform is organized into the following major infrastructure domains:

**Core EKS Cluster** — Provisioning of the Amazon EKS control plane, cluster networking integration, IAM roles, security groups, node groups, and Kubernetes access configuration.

**Add-ons** — Deployment and configuration of critical Kubernetes operational services including AWS Load Balancer Controller, ExternalDNS, Karpenter, observability stack, ingress controllers, autoscaling components, and platform integrations.

**Dataplane** — Provisioning of managed AWS backend services supporting the microservices platform, including Amazon RDS MySQL, Amazon RDS PostgreSQL, DynamoDB, ElastiCache Redis, and Amazon SQS for persistence, caching, and asynchronous messaging workloads.

**Applications** — Kubernetes workloads, Helm releases, ingress resources, GitOps-managed deployments, and production retail microservices deployed into the EKS platform.