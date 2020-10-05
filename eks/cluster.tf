/*
  Configures an EKS cluster using the terraform-aws-modules/eks/aws module and kubernetes provider
  It is a basic cluster with a single node group of 3 nodes with no option to scale
*/
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "1.13.2"
}

module "eks" {
  source           = "terraform-aws-modules/eks/aws"
  cluster_name     = var.app_name
  cluster_version  = "1.17"
  kubeconfig_aws_authenticator_env_variables = {AWS_PROFILE = var.aws_profile}
  manage_aws_auth = "false"
  subnets          = module.vpc.private_subnets
  vpc_id           = module.vpc.vpc_id
  write_kubeconfig = "true"

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    node-group-1 = {
      name             = "${var.app_name}-node-group-1"
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3


      tags = {
        Name = "${var.app_name}-node-group-1"
      }

      instance_type = "t2.small"
      k8s_labels = {
        Environment = var.app_name
      }
    }
  }
}