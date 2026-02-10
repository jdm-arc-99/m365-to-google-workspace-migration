module "vpc" {
  source          = "../../modules/vpc-network"
  region          = var.region
  network_name    = "migration-vpc"
  subnet_cidr     = "10.0.0.0/24"
  admin_ip_ranges = var.admin_ip_ranges
}

# Add IAM roles for GCDS and Terraform service accounts here
# resource "google_project_iam_member" "terraform_admin" { ... }
