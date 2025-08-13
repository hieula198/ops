resource "aws_key_pair" "key_pair" {
  key_name   = "${var.project}-key-pair"
  public_key = file("./data/ssh/id_ed25519.pub")
}

module "secrets_bucket" {
  source = "./modules/s3"

  project = var.project
}

module "ecr" {
  source = "./modules/ecr"

  project = var.project
}

module "vpc" {
  source = "./modules/vpc"

  project                    = var.project
  vpc_az                     = var.vpc_az
  vpc_cidr_block             = var.vpc_cidr_block
  vpc_number_private_subnets = var.vpc_number_private_subnets
  vpc_number_public_subnets  = var.vpc_number_public_subnets
  create_vpc                 = true
  create_nat                 = true
}

module "sg" {
  source = "./modules/sg"

  project       = var.project
  vpc           = module.vpc.vpc_id
  white_list_ip = var.white_list_ip

  depends_on = [module.vpc]
}

module "alb" {
  source = "./modules/alb"

  project             = var.project
  create_alb          = true
  enable_http         = true
  enable_https        = true
  create_target_group = true

  vpc             = module.vpc.vpc_id
  subnets         = module.vpc.public_subnet_ids
  sgs             = [module.sg.public_sg_id]
  wildcard_domain = var.wildcard_domain
  dns_host_zone   = var.dns_host_zone

  depends_on = [module.vpc]
}

module "ecs" {
  source = "./modules/ecs"

  alb             = module.alb.arn_alb
  alb_listener    = module.alb.arn_https_listener
  vpc             = module.vpc
  subnets         = module.vpc.private_subnet_ids
  security_groups = [module.sg.private_sg_id]
  key_pair_name   = aws_key_pair.key_pair.key_name
  project         = var.project
  region          = var.aws_region
  secret_bucket   = module.secrets_bucket.bucket_name
  policy_arns = [
    module.ecr.frontend_pull_policy,
    module.ecr.backend_pull_policy,
  ]

  depends_on = [module.vpc, module.sg, module.secrets_bucket, module.ecr, module.alb]
}

resource "aws_instance" "tunnel_instance" {

  ami                    = var.utility_instance_ami
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [module.sg.public_sg_id]

  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project}-tunnel-instance"
  }
}

resource "aws_ec2_instance_connect_endpoint" "ice" {
  subnet_id = module.vpc.private_subnet_ids[0]

  tags = {
    Name = "${var.project}-utility-instance-connect-endpoint"
  }
}

module "cloudfront" {
  source = "./modules/route53-cloudfront"

  project         = var.project
  wildcard_domain = var.wildcard_domain
  dns_host_zone   = var.dns_host_zone
  alb_dns_name    = module.alb.dns_alb
}