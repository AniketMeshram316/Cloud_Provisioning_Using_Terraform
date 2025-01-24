module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = var.vpc_cidr
  public_subnet  = var.public_subnet
  private_subnet = var.private_subnet
  public_names   = var.public_names
  private_names  = var.private_names
}