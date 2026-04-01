locals {
  base_tags = merge(
    var.tags,
    {
      managed_by   = "terraform"
      architecture = "hub-and-spoke"
    }
  )
}