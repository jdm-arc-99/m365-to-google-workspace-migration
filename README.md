# Microsoft 365 to Google Workspace migration

This repository contains the architecture, infrastructure, and automation logic for the 5,000-user migration project.

## Project Vision
To migrate 5,000 Tech and Data users to a standardized Google Workspace environment by **April 30, 2026**, while maintaining data integrity and compliance.

## Repository Layout (TOGAF Aligned)
- `architecture/`: ADM Phase artifacts (Strategy, Vision, Technical Design).
- `infrastructure/`: Terraform-managed GCE and VPC components.
- `automation/`: PowerShell provisioning and GAM administration scripts.
- `governance/`: Risk management, compliance, and cost tracking.
- `strategy/`: Wave models and cutover planning.

## Getting Started
1. **Explore Architecture**: Review the [Migration Playbook](file:///home/marshall-999/StudioProjects/m365-to-google-workspace-migration/architecture/vision/migration_playbook.md).
2. **Infrastructure**: Navigate to `infrastructure/terraform` to initialize the provider and modules.
3. **Automation**: Check `automation/powershell` for the server installation suite.

## Tech Stack
- **IaC**: Terraform v1.5+
- **Scripts**: PowerShell 5.1+, GAM ADV-XTD3
- **Platform**: Google Cloud Platform (GCE, Cloud Identity)
