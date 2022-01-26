# Worker instance 1 - ARM
resource "oci_core_instance" "arm1_instance" {
  # ===== Required for resource =====
  # Availability domain - always free account has only one region and one availability domain
  availability_domain = data.oci_identity_availability_domain.ad.name
  # Compartment ID - where instance will be provisioned
  compartment_id = var.compartment_ocid
  # Shape - VM.Standard.E2.1.Micro and VM.Standard.A1.Flex are always free eligible
  shape = "VM.Standard.A1.Flex"

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
    hostname_label            = var.arm1_name
    private_ip                = "10.11.20.101"
    subnet_id                 = oci_core_subnet.public_subnet.id
  }

  # Instance name
  display_name = var.arm1_name

  # Enable in-transit encryption for the data volume's paravirtualized attachment
  is_pv_encryption_in_transit_enabled = "true"

  # Metadata - SSH authorized key or User data
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    # TODO: user_data
  }

  # Instance shape - CPU and RAM
  shape_config {
    memory_in_gbs = "12"
    ocpus         = "2"
  }
  # Boot volume - size and image
  source_details {
    boot_volume_size_in_gbs = "50"
    source_id               = var.images[oci_core_instance.arm1_instance.shape][var.region]
    source_type             = "image"
  }
}
