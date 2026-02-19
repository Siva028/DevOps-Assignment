module "vpc" {
  source = "../../modules/vpc"
}
module "alb" {
  source = "../../modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}
module "ecr" {
  source = "../../modules/ecr"
}
module "ecs" {
  source = "../../modules/ecs"

  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_subnet_ids
  alb_security_group_id     = module.alb.alb_security_group_id
  backend_target_group_arn  = module.alb.backend_target_group_arn
  frontend_target_group_arn = module.alb.frontend_target_group_arn
  alb_dns_name              = module.alb.alb_dns_name


  backend_image  = "474668402139.dkr.ecr.ap-south-1.amazonaws.com/pgagi-backend:v1"
  frontend_image = "474668402139.dkr.ecr.ap-south-1.amazonaws.com/pgagi-frontend:v1"

  desired_count            = 1
  enable_autoscaling       = true
  autoscaling_max_capacity = 3

}
