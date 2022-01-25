resource "oci_core_virtual_network" "hs_vcn" {
  cidr_block     = "10.11.20.0/24"
  compartment_id = var.compartment_ocid
  display_name   = "hs-vcn"
  dns_label      = "hsvcn"
}
