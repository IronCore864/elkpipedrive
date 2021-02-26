module "network" {
  source = "./modules/networking"

  vpc_cidr_block  = var.main_vpc_cidr
  vpc_name        = var.main_vpc_name
  public_subnets  = var.main_vpc_public_subnets
  private_subnets = var.main_vpc_private_subnets
}

module "cluster" {
  source = "./modules/eks"

  cluster_name      = var.cluster_name
  nodegroup_name    = var.nodegroup_name
  vpc_id            = module.network.vpc_id
  worker_subnet_ids = module.network.private_subnet_ids
}
