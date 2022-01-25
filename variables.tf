# Required for OCI provider
variable "tenancy_ocid" {
  description = "Tenancy Oracle Cloud Infrastructure Identifier"
}

variable "user_ocid" {
  description = "User Oracle Cloud Infrastructure Identifier"
}

variable "private_key" {
  description = "SSH private key"
}

variable "fingerprint" {
  description = "Fingerprint"
}

variable "region" {
  description = "Region name"
  default = "eu-amsterdam-1"
}

# Required for all resources
variable "compartment_ocid" {
  description = "Compartment Oracle Cloud Infrastructure Identifier"
}

variable "ad_region_mapping" {
  type = map(string)

  default = {
    eu-amsterdam-1 = 1
  }
}

# Required for instances
variable "ssh_public_key" {
  description = "SSH public key"
}

variable "images" {
  type = map(string)

  default = {
    eu-amsterdam-1   = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaa7sqau7d2qoi473e2r7xp5bsxfuqxlejmepd6njt5xpyzkg2puvuq"
  }
}

variable "arm1_name" {
  description = "Instance name"
  default = "rohan"
}
