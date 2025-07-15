
# Infrastructure Management

This repository contains Infrastructure as Code (IaC) for managing our various deployment environments: ECS, EKS, and on-premise infrastructure.

## Infrastructure Components

| Component | Description |
|-----------|-------------|
| ECS | Amazon Elastic Container Service for container orchestration |
| EKS | Amazon Elastic Kubernetes Service for Kubernetes management |
| On-Premise | Self-hosted infrastructure managed with Ansible |

## Completion Progress
| Component | Status | Progress |
|-----------|--------|----------|
| ECS | In Progress | ⏳ 0%     |
| EKS | Planning | 🔄 0%    |
| On-Premise | Complete | ✅ 100%   |

## Directory Structure

- `ecs/` - ECS infrastructure configuration
- `eks/` - EKS infrastructure configuration
- `on-premise/` - On-premise infrastructure with Ansible

## Getting Started

Each infrastructure component has its own setup instructions:

```bash
# For ECS deployment
cd ecs && make deploy

# For EKS deployment
cd eks && make apply

# For on-premise deployment
cd on-premise && make all
```

## Prerequisites

- AWS CLI configured (for ECS/EKS)
- kubectl (for EKS)
- Ansible (for on-premise)
- Terraform
- Python 3.x

## Author

This infrastructure automation is maintained by the DevOps team. For questions or support, please contact:

- Name: hieu.la [hrcp.hieu@gmail.com](mailto:hrcp.hieu@gmail.com)