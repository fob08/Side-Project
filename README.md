# Infrastructure Configuration
## Overview
This project involves deploying infrastructure components. The initial scope includes creating an RDS database, AWS image registry, and hosting an ECS application. The deployment will be managed using Terraform, and modularization will be implemented to adhere to best practices. Additionally, the Terraform state file will be stored in an S3 backend.

## Deployment Environments
The infrastructure will be deployed to two environments:

**Development (Dev):** Used for testing and development purposes.
**Production (Prod):** Production environment serving live traffic.

# Tasks
- Create Terraform modules for RDS, AWS image registry, and ECS application.
- Implement infrastructure deployment for Dev and Prod environments.
- Configure S3 backend to store Terraform state files securely.
- Adhere to best practices for Terraform module development and infrastructure provisioning.
