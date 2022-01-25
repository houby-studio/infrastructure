terraform {
  required_providers {
    # Oracle Cloud Infrastructure
    oci = {
      source  = "hashicorp/oci"
      version = "~> 4.60.0"
    }
  }

  # Terraform version
  required_version = ">= 1.1.4"
}
