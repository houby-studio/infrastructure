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
  default     = "eu-amsterdam-1"
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
  type = map(map(string))

  default = {
    "VM.Standard.A1.Flex" = {
      eu-amsterdam-1 = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaadixwulpfjs4yqwhnzjorjmxaalrlwmma35nntqdkvmd6zu76fuaq"
    }
    "VM.Standard.E2.1.Micro" = {
      eu-amsterdam-1 = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaa5iucvph4gjebjfwu3xaaabmttn5cwsmudlofdqe33lstmpwi2ama"
    }
  }
}

variable "instance_names" {
  type        = list(string)
  description = "Instance names"

  default = [
    "minastirith",
    "minasmorgul",
    "rohan",
    "gondor"
  ]
}

# Required for vcn
variable "vcn_prefix" {
  description = "Prefix for all VCN resources"
}

variable "vcn_cidr" {
  description = "Prefix for all VCN resources"
  default     = "10.11.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Prefix for all VCN resources"
  default     = "10.11.20.0/24"
}