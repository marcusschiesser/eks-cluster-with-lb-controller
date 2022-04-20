provider "aws" {
  region = "eu-central-1"
}

module "cluster" {
  source         = "./_modules/cluster"
  cluster_name   = "my-cluster"
  aws_region     = "eu-central-1"
  aws_account_id = "111111111111"
  instance_types = ["m5.xlarge"]
  vpc_id         = "vpc-11111111111111111"
  private_subnets = [
    "subnet-11111111111111111",
    "subnet-22222222222222222",
    "subnet-33333333333333333"
  ]
  public_subnets = [
    "subnet-44444444444444444",
    "subnet-55555555555555555",
    "subnet-66666666666666666"
  ]
}
