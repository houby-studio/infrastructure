# This configuration uses all available instances in the always free tier

locals {
  x64_shape = {
    "name" = "VM.Standard.E2.1.Micro"
    "cpu"  = "1"
    "ram"  = "1"
  }
  arm_shape = {
    "name" = "VM.Standard.A1.Flex"
    "cpu"  = "2"
    "ram"  = "12"
  }
  instance_shapes = {
    "0" = local.x64_shape.name
    "1" = local.x64_shape.name
    "2" = local.arm_shape.name
    "3" = local.arm_shape.name
  }
}

# Instances
resource "oci_core_instance" "instance" {
  count = 4

  # ===== Required for resource =====
  # Availability domain - always free account has only one region and one availability domain
  availability_domain = data.oci_identity_availability_domain.ad.name
  # Compartment ID - where instance will be provisioned
  compartment_id = var.compartment_ocid
  # Shape - VM.Standard.E2.1.Micro and VM.Standard.A1.Flex are always free eligible
  shape = lookup(local.instance_shapes, count.index)

  # ===== Optional for resource =====
  # Agent configuration
  agent_config {
    # Optional for agent config
    is_management_disabled = "false"
    is_monitoring_disabled = "false"
    plugins_config {
      # Required for plugin config
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      # Required for plugin config
      desired_state = "ENABLED"
      name          = "OS Management Service Agent"
    }
    plugins_config {
      # Required for plugin config
      desired_state = "ENABLED"
      name          = "Compute Instance Run Command"
    }
    plugins_config {
      # Required for plugin config
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      # Required for plugin config
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      # Required for plugin config
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }

  # Availability configuration
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }

  # Networking configuration
  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    hostname_label            = var.instance_names[count.index]
    private_ip                = cidrhost(oci_core_subnet.public_subnet.cidr_block, 101 + count.index)
    subnet_id                 = oci_core_subnet.public_subnet.id
  }

  # Instance name
  display_name = var.instance_names[count.index]

  # Enable in-transit encryption for the data volume's paravirtualized attachment
  is_pv_encryption_in_transit_enabled = "true"

  # Metadata - SSH authorized key or User data
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  # Instance shape - CPU and RAM
  shape_config {
    memory_in_gbs = local.x64_shape.ram
    ocpus         = local.x64_shape.cpu
  }
  # Boot volume - size and image
  source_details {
    boot_volume_size_in_gbs = "50"
    source_id               = var.images[lookup(local.instance_shapes, count.index)][var.region]
    source_type             = "image"
  }
}
