# Retail Store Microservices Production Deployment

Production-grade cloud-native retail platform deployed on AWS using Terraform-based Infrastructure as Code (IaC) with remote state management in Amazon S3. The platform is designed for high availability, scalability, security, and fully automated continuous delivery.
#### Core Infrastructure
 - Amazon VPC across 3 Availability Zones
 - Public and Private subnet segmentation
 - Internet Gateway + Multi-AZ NAT Gateways
 - Amazon EKS cluster with multi-AZ worker nodes
 - AWS IAM Roles and Policies
 - AWS Secrets Manager
#### Kubernetes Platform Components
 - AWS Load Balancer Controller
 - Karpenter dynamic node provisioning
 - Horizontal Pod Autoscaler (HPA)
 - ExternalDNS with Amazon Route 53
 - Helm-based application deployments
 
#### Dataplane Services
 - Amazon RDS MySQL
 - Amazon RDS PostgreSQL
 - Amazon DynamoDB
 - Amazon ElastiCache Redis
 - Amazon SQS
 #### DevOps & GitOps
 - Terraform infrastructure provisioning
 - GitHub Actions CI/CD pipelines
 - ArgoCD GitOps deployments
 - Argo Rollouts for progressive delivery
 - Amazon ECR container registry
#### Observability Stack
 - AWS Distro for OpenTelemetry
 - Amazon CloudWatch
 - Amazon Managed Prometheus
 - Amazon Managed Grafana
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



```bash
├── 01_EKS_Cluster_Environment
│   ├── 01_VPC_terraform-manifests
│   │   ├── c1-versions.tf
│   │   ├── c2-variables.tf
│   │   ├── c3-vpc.tf
│   │   ├── c4-outputs.tf
│   │   ├── modules
│   │   │   └── vpc
│   │   │       ├── datasources-and-locals.tf
│   │   │       ├── main.tf
│   │   │       ├── outputs.tf
│   │   │       └── variables.tf
│   │   └── terraform.tfvars
│   ├── 02_EKS_terraform-manifests_with_addons
│   │   ├── c1-versions.tf
│   │   ├── c10_eks_outputs.tf
│   │   ├── c11-podidentityagent-eksaddon.tf
│   │   ├── c12-helm-and-kubernetes-providers.tf
│   │   ├── c13-podidentity-assumerole.tf
│   │   ├── c14-01-lbc-iam-policy-datasources.tf
│   │   ├── c14-02-lbc-iam-policy-and-role.tf
│   │   ├── c14-03-lbc-eks-pod-identity-association.tf
│   │   ├── c14-04-lbc-helm-install.tf
│   │   ├── c15-01-ebscsi-iam-policy-and-role.tf
│   │   ├── c15-02-ebscsi-eks-pod-identity-association.tf
│   │   ├── c15-03-ebscsi-eksaddon.tf
│   │   ├── c16-01-secretstorecsi-helm-install.tf
│   │   ├── c16-02-secretstorecsi-ascp-helm-install.tf
│   │   ├── c17-01-externaldns-iam-policy-and-role.tf
│   │   ├── c17-02-externaldns-pod-identity-association.tf
│   │   ├── c17-03-externaldns-eksaddon.tf
│   │   ├── c18_eksaddon_metrics_server.tf
│   │   ├── c2-variables.tf
│   │   ├── c3_remote-state.tf
│   │   ├── c4_datasources_and_locals.tf
│   │   ├── c5_eks_tags.tf
│   │   ├── c6_eks_cluster_iamrole.tf
│   │   ├── c7_eks_cluster.tf
│   │   ├── c8_eks_nodegroup_iamrole.tf
│   │   ├── c9_eks_nodegroup_private.tf
│   │   ├── env
│   │   │   ├── dev.tfvars
│   │   │   ├── prod.tfvars
│   │   │   └── staging.tfvars
│   │   └── terraform.tfvars
│   ├── 03_KARPENTER_terraform-manifests
│   │   ├── c1_versions.tf
│   │   ├── c2_variables.tf
│   │   ├── c3_01_vpc_remote_state.tf
│   │   ├── c3_02_eks_remote_state.tf
│   │   ├── c4_datasources_and_locals.tf
│   │   ├── c5_helm_and_kubernetes_providers.tf
│   │   ├── c6_01_karpenter_controller_iam_role.tf
│   │   ├── c6_02_karpenter_controller_iam_policy.tf
│   │   ├── c6_03_karpenter_pod_identity_association.tf
│   │   ├── c6_04_karpenter_node_iam_role.tf
│   │   ├── c6_05_karpenter_access_entry.tf
│   │   ├── c6_06_karpenter_helm_install.tf
│   │   ├── c6_07_karpenter_sqs_queue.tf
│   │   ├── c6_08_karpenter_eventbridge_rules.tf
│   │   ├── c6_09_karpenter_service_linked_roles.tf
│   │   └── terraform.tfvars
│   ├── 04_KARPENTER_k8s-manifests
│   │   ├── 01_ec2nodeclass.yaml
│   │   ├── 02_nodepool_ondemand.yaml
│   │   └── 03_nodepool_spot.yaml
│   ├── 05_OPENTELEMTRY_terraform-manifests
│   │   ├── c1_versions.tf
│   │   ├── c2_variables.tf
│   │   ├── c3_01_vpc_remote_state.tf
│   │   ├── c3_02_eks_remote_state.tf
│   │   ├── c4_datasources_and_locals.tf
│   │   ├── c5_helm_and_kubernetes_providers.tf
│   │   ├── c6_01_adot_collector_iam_role.tf
│   │   ├── c6_02_adot_collector_iam_policy.tf
│   │   ├── c6_03_adot_pod_identity_association.tf
│   │   ├── c6_04_eks_addon_certmanager.tf
│   │   ├── c6_05_eks_addon_adot.tf
│   │   ├── c6_06_eks_addon_prometheus_node_exporter.tf
│   │   ├── c6_07_eks_addon_kube_state_metrics.tf
│   │   ├── c6_09_adot_k8s_cluster_role_and_rolebinding.tf
│   │   ├── c7_amp_prometheus_workspace.tf
│   │   ├── c8_01_amg_grafana_iam_policy.tf
│   │   ├── c8_02_amg_grafana_iam_role.tf
│   │   ├── c8_03_amg_grafana.tf
│   │   └── terraform.tfvars
└── 02_RetailStore_App_Environment
    ├── 01_RetailStore_AWS_Dataplane
    │   ├── 01_AWS_Data_Plane_terraform-manifests
    │   │   ├── c1_versions.tf
    │   │   ├── c2_variables.tf
    │   │   ├── c3_01_vpc_remote_state.tf
    │   │   ├── c3_02_eks_remote_state.tf
    │   │   ├── c4_datasources_and_locals.tf
    │   │   ├── c5_01_podidentity_assumerole.tf
    │   │   ├── c5_02_secretstorecsi_iam_policy.tf
    │   │   ├── c6_01_catalog_rds_mysql_security_group.tf
    │   │   ├── c6_02_catalog_rds_mysql_dbsubnet_group.tf
    │   │   ├── c6_03_catalog_rds_mysql_credentials.tf
    │   │   ├── c6_04_catalog_rds_mysql_dbinstance.tf
    │   │   ├── c6_05_catalog_sa_iam_role.tf
    │   │   ├── c6_06_catalog_sa_eks_pod_identity_association.tf
    │   │   ├── c7_01_cart_dynamoDB_iam_policy_and_role.tf
    │   │   ├── c7_02_cart_eks_pod_identity_association.tf
    │   │   ├── c7_03_cart_dynamodb_table.tf
    │   │   ├── c8_01_checkout_redis_security_group.tf
    │   │   ├── c8_02_checkout_redis_subnet_group.tf
    │   │   ├── c8_03_checkout_redis_cluster.tf
    │   │   ├── c9_01_orders_postgresql_security_group.tf
    │   │   ├── c9_02_orders_postgresql_db_subnet_group.tf
    │   │   ├── c9_03_orders_postgresql_dbinstance.tf
    │   │   ├── c9_04_orders_postgresql_sa_iam_role.tf
    │   │   ├── c9_05_orders_postgresql_sa_eks_pod_identity_association.tf
    │   │   ├── c9_06_orders_aws_sqs_queue.tf
    │   │   └── c9_07_orders_aws_sqs_iam_policy.tf
    │   ├── create-aws-dataplane.sh
    │   └── delete-aws-dataplane.sh
```