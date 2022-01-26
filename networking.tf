# Virtual network
resource "oci_core_virtual_network" "primary_vcn" {
  cidr_block     = "10.11.20.0/24"
  compartment_id = var.compartment_ocid
  display_name   = "${vcn_prefix}-vcn"
  dns_label      = "${vcn_prefix}vcn"
}

# Public subnet
resource "oci_core_subnet" "public_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "${vcn_prefix}-public-subnet"
  dns_label         = "public"
  security_list_ids = [oci_core_security_list.public_security_list.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.primary_vcn.id
  route_table_id    = oci_core_route_table.public_route_table.id
  dhcp_options_id   = oci_core_virtual_network.primary_vcn.default_dhcp_options_id
}

# Internet gateway - for public subnet - allows ingress and egress connections
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "${vcn_prefix}-internet-gateway"
  vcn_id         = oci_core_virtual_network.primary_vcn.id
}

# Route table for public subnet
resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.primary_vcn.id
  display_name   = "${vcn_prefix}-public-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

# Security list for public subnet
resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.primary_vcn.id
  display_name   = "${vcn_prefix}-public_security_list"

  # Allow full communication to internet
  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  # SSH
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  # HTTP
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }

  # HTTPS
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "443"
      min = "443"
    }
  }
}
