#### Region Details ####
provider "aws" {
  region = "${var.aws_region}"
}

#### Module To Create VPC ####
module "vpc" {
  source            = "git::ssh://git@github.com/opstree-terraform/vpc"
  cidr              = "${var.cidr}"
  name              = "${var.vpc_name}"
  route53_zone_name = "${var.route53_zone_name}"
}

#### Module to Create Key Pair ####
module "key_pair" {
  source          = "git::ssh://git@github.com/opstree-terraform/key_pair"
  public_key_path = "${var.pub_key_path}"
  name            = "${var.vpc_name}-key"
}

#### Module to Create Security Group ####
module "security_group" {
  source          = "git::ssh://git@github.com/opstree-terraform/pub_ssh_sg"
  vpc_id          = "${module.vpc.id}"
}

#### Module to Create Public Subnet for AZ_A ####
module "pub_sn_a" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet"
  vpc_id                  = "${module.vpc.id}"
  cidr                    = "${var.pub_sn_aza_cidr}"
  az                      = "${var.aws_region}a"
  name                    = "${var.pub_sn_aza_name}"
  map_public_ip_on_launch = "false"
}

#### Module to Create Public Subnet for AZ_B ####
module "pub_sn_b" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet"
  vpc_id                  = "${module.vpc.id}"
  cidr                    = "${var.pub_sn_azb_cidr}"
  az                      = "${var.aws_region}b"
  name                    = "${var.pub_sn_azb_name}"
  map_public_ip_on_launch = "false"
}

#### Module to Create Private Subnet for AZ_A ####
module "priv_sn_a" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet"
  vpc_id                  = "${module.vpc.id}"
  cidr                    = "${var.priv_sn_aza_cidr}"
  az                      = "${var.aws_region}a"
  name                    = "${var.priv_sn_aza_name}"
}

#### Module to Create Private Subnet for AZ_B ####
module "priv_sn_b" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet"
  vpc_id                  = "${module.vpc.id}"
  cidr                    = "${var.priv_sn_azb_cidr}"
  az                      = "${var.aws_region}b"
  name                    = "${var.priv_sn_azb_name}"
}

#### Module to Create DB Private Subnet for AZ_A ####
module "db_sn_a" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet"
  vpc_id                  = "${module.vpc.id}"
  cidr                    = "${var.db_sn_aza_cidr}"
  az                      = "${var.aws_region}a"
  name                    = "${var.db_sn_aza_name}"
}

#### Module to Create DB Private Subnet for AZ_A ####
module "db_sn_b" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet"
  vpc_id                  = "${module.vpc.id}"
  cidr                    = "${var.db_sn_azb_cidr}"
  az                      = "${var.aws_region}b"
  name                    = "${var.db_sn_azb_name}"
}

#### Module to Create Private Route Table ####
module "priv_route_table" {
  source         = "git::ssh://git@github.com/opstree-terraform/pvt_route_table"
  vpc_id                  = "${module.vpc.id}"
  pub_sn_id               = "${module.pub_sn_a.id}"
  vpc_name                = "${var.vpc_name}"
}

#### Module to Associate Public Subnet AZ_A to Public Route Table ####
module "pub_sn_a_association" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet_association"
  subnet_id              = "${module.pub_sn_a.id}"
  route_table_id         = "${module.vpc.public_route_table_id}"
}

#### Module to Associate Public Subnet AZ_B to Public Route Table ####
module "pub_sn_b_association" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet_association"
  subnet_id              = "${module.pub_sn_b.id}"
  route_table_id         = "${module.vpc.public_route_table_id}"
}

#### Module to Associate Private Subnet AZ_A to Private Route Table ####
module "priv_sn_a_association" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet_association"
  subnet_id              = "${module.priv_sn_a.id}"
  route_table_id         = "${module.priv_route_table.route_table_id}"
}

#### Module to Associate Private Subnet AZ_B to Private Route Table ####
module "priv_sn_b_association" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet_association"
  subnet_id              = "${module.priv_sn_b.id}"
  route_table_id         = "${module.priv_route_table.route_table_id}"
}

#### Module to Associate  DB Private Subnet AZ_A to Private Route Table ####
module "db_sn_a_association" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet_association"
  subnet_id              = "${module.db_sn_a.id}"
  route_table_id         = "${module.priv_route_table.route_table_id}"
}

#### Module to Associate DB Private Subnet AZ_B to Private Route Table ####
module "db_sn_b_association" {
  source         = "git::ssh://git@github.com/opstree-terraform/subnet_association"
  subnet_id              = "${module.db_sn_b.id}"
  route_table_id         = "${module.priv_route_table.route_table_id}"
}

#### Module to Create Web Security Group for ALB ####
module "web_security_group" {
  source          = "git::ssh://git@github.com/opstree-terraform/pub_web_sg"
  vpc_id          = "${module.vpc.id}"
}

#### Module to Launch ALB with Public Subnet ####
module "pub-alb" {
  source                        = "git::ssh://git@github.com/opstree-terraform/alb"
  alb_name                      = "${var.pub_alb_name}"
  alb_security_groups           = ["${module.web_security_group.id}"]
#   certificate_arn               = "arn:aws:iam::123456789012:server-certificate"
  health_check_path             = "/login"
  subnets                       = ["${module.pub_sn_a.id}", "${module.pub_sn_b.id}"]
  tags                          = "${map("Environment", "test")}"
  vpc_id                        = "${module.vpc.id}"
}

#### Module to Launch ALB with Private Subnet ####
module "priv-alb" {
  source                        = "git::ssh://git@github.com/opstree-terraform/alb"
  alb_name                      = "${var.priv_alb_name}"
  alb_security_groups           = ["${module.web_security_group.id}"]
#   certificate_arn               = "arn:aws:iam::123456789012:server-certificate"
  health_check_path             = "/login"
  subnets                       = ["${module.priv_sn_a.id}", "${module.priv_sn_b.id}"]
  tags                          = "${map("Environment", "test")}"
  vpc_id                        = "${module.vpc.id}"
}

#### Module for Launch Configuration and Autoscaling of MYPAT_FRONTEND ####
module "aws_launch_configuration_mypatfe" {
  source               = "git::ssh://git@github.com/opstree-terraform/launch_configuration"
  name                 = "${var.mypatfe_launch_configuration_name}"
  lc_name              = "${var.mypatfe_lc_name}"
  image_id             = "${var.mypatfe_ami}"
  aws_region           = "${var.aws_region}"
  key_name             = "${module.key_pair.id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${module.security_group.id}"]
  root_volume_type     = "gp2"
  root_volume_size     = "10"
}

module "asg_mypatfe" {
  source = "git::ssh://git@github.com/opstree-terraform/autoscaling_group"
  name                      = "${var.vpc_name}"
  asg_name                  = "${var.vpc_name}-mypatfe-asg"
#  vpc_zone_identifier       = ["${module.priv_sn_a.id}", "${module.priv_sn_b.id}"]
  vpc_zone_identifier       = ["${module.priv_sn_a.id}"]
  launch_configuration      = "${module.aws_launch_configuration_mypatfe.this_launch_configuration_id}"
  # load_balancers            = ["${var.alb_name}", "${var.db_alb_name}"]
  target_group_arns         = ["${module.priv-alb.target_group_arn}", "${module.pub-alb.target_group_arn}"]
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  key                       = "${var.key}"
  value                     = "${var.value}"
}

#### Module for Launch Configuration and Autoscaling of MYPAT_DS ####
module "aws_launch_configuration_mypatds" {
  source               = "git::ssh://git@github.com/opstree-terraform/launch_configuration"
  name                 = "${var.mypatds_launch_configuration_name}"
  lc_name              = "${var.mypatds_lc_name}"
  image_id             = "${var.mypatds_ami}"
  aws_region           = "${var.aws_region}"
  key_name             = "${module.key_pair.id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${module.security_group.id}"]
  root_volume_type     = "gp2"
  root_volume_size     = "10"
}

module "asg_mypatds" {
  source = "git::ssh://git@github.com/opstree-terraform/autoscaling_group"
  name                      = "${var.vpc_name}"
  asg_name                  = "${var.vpc_name}-mypatds-asg"
#  vpc_zone_identifier       = ["${module.priv_sn_a.id}", "${module.priv_sn_b.id}"]
  vpc_zone_identifier       = ["${module.priv_sn_a.id}"]  
  launch_configuration      = "${module.aws_launch_configuration_mypatds.this_launch_configuration_id}"
  # load_balancers            = ["${var.alb_name}", "${var.db_alb_name}"]
  target_group_arns         = ["${module.priv-alb.target_group_arn}", "${module.pub-alb.target_group_arn}"]
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  key                       = "${var.key}"
  value                     = "${var.value}"
}

#### Module for Launch Configuration and Autoscaling of MYPAT_API ####
module "aws_launch_configuration_mypatapi" {
  source               = "git::ssh://git@github.com/opstree-terraform/launch_configuration"
  name                 = "${var.mypatapi_launch_configuration_name}"
  lc_name              = "${var.mypatapi_lc_name}"
  image_id             = "${var.mypatapi_ami}"
  aws_region           = "${var.aws_region}"
  key_name             = "${module.key_pair.id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${module.security_group.id}"]
  root_volume_type     = "gp2"
  root_volume_size     = "10"
}

module "asg_mypatapi" {
  source = "git::ssh://git@github.com/opstree-terraform/autoscaling_group"
  name                      = "${var.vpc_name}"
  asg_name                  = "${var.vpc_name}-mypatapi-asg"
#  vpc_zone_identifier       = ["${module.priv_sn_a.id}", "${module.priv_sn_b.id}"]
  vpc_zone_identifier       = ["${module.priv_sn_a.id}"]
  launch_configuration      = "${module.aws_launch_configuration_mypatapi.this_launch_configuration_id}"
  # load_balancers            = ["${var.alb_name}", "${var.db_alb_name}"]
  target_group_arns         = ["${module.priv-alb.target_group_arn}", "${module.pub-alb.target_group_arn}"]
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  key                       = "${var.key}"
  value                     = "${var.value}"
}

#### Module for Launch Configuration and Autoscaling of CMS_DS ####
module "aws_launch_configuration_cmsds" {
  source               = "git::ssh://git@github.com/opstree-terraform/launch_configuration"
  name                 = "${var.cmsds_launch_configuration_name}"
  lc_name              = "${var.cmsds_lc_name}"
  image_id             = "${var.cmsds_ami}"
  aws_region           = "${var.aws_region}"
  key_name             = "${module.key_pair.id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${module.security_group.id}"]
  root_volume_type     = "gp2"
  root_volume_size     = "10"
}

module "asg_cmsds" {
  source = "git::ssh://git@github.com/opstree-terraform/autoscaling_group"
  name                      = "${var.vpc_name}"
  asg_name                  = "${var.vpc_name}-cmsds-asg"
#  vpc_zone_identifier       = ["${module.priv_sn_a.id}", "${module.priv_sn_b.id}"]
  vpc_zone_identifier       = ["${module.priv_sn_a.id}"]
  launch_configuration      = "${module.aws_launch_configuration_cmsds.this_launch_configuration_id}"
  # load_balancers            = ["${var.alb_name}", "${var.db_alb_name}"]
  target_group_arns         = ["${module.priv-alb.target_group_arn}", "${module.pub-alb.target_group_arn}"]
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  key                       = "${var.key}"
  value                     = "${var.value}"
}

#### Module for Launch Configuration and Autoscaling of CMS_API ####
module "aws_launch_configuration_cmsapi" {
  source               = "git::ssh://git@github.com/opstree-terraform/launch_configuration"
  name                 = "${var.cmsapi_launch_configuration_name}"
  lc_name              = "${var.cmsapi_lc_name}"
  image_id             = "${var.cmsapi_ami}"
  aws_region           = "${var.aws_region}"
  key_name             = "${module.key_pair.id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${module.security_group.id}"]
  root_volume_type     = "gp2"
  root_volume_size     = "10"
}

module "asg_cmsapi" {
  source = "git::ssh://git@github.com/opstree-terraform/autoscaling_group"
  name                      = "${var.vpc_name}"
  asg_name                  = "${var.vpc_name}-cmsapi-asg"
#  vpc_zone_identifier       = ["${module.priv_sn_a.id}", "${module.priv_sn_b.id}"]
  vpc_zone_identifier       = ["${module.priv_sn_a.id}"]
  launch_configuration      = "${module.aws_launch_configuration_cmsapi.this_launch_configuration_id}"
  # load_balancers            = ["${var.alb_name}", "${var.db_alb_name}"]
  target_group_arns         = ["${module.priv-alb.target_group_arn}", "${module.pub-alb.target_group_arn}"]
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  key                       = "${var.key}"
  value                     = "${var.value}"
}

#### Autoscaling Policy for MYPAT FRONTEND ####
module "asg_policy_mypatfe" {
  source = "git::ssh://git@github.com/opstree-terraform/autoscaling_policy"
  stack_item_fullname      = "${var.stack_name_mypatfe}"
  policy_name              = "${var.policy_name_mypatfe}"
  asg_name                 = "${module.asg_mypatfe.this_autoscaling_group_id}"
  adjustment_type          = "${var.adjustment_type}"
  comparison_operator      = "${var.comparison_operator}"
  cooldown                 = "${var.cooldown}"
  evaluation_periods       = "${var.evaluation_periods}"
  metric_name              = "${var.metric_name}"
  period                   = "${var.period}"
  scaling_adjustment       = "${var.scaling_adjustment}"
  threshold                = "${var.threshold}"
  treat_missing_data       = "${var.treat_missing_data}"
}

#### Autoscaling Policy for MYPAT DS ####
module "asg_policy_mypatds" {
  source = "git::ssh://git@github.com/opstree-terraform/autoscaling_policy"
  stack_item_fullname      = "${var.stack_name_mypatds}"
  policy_name              = "${var.policy_name_mypatds}"
  asg_name                 = "${module.asg_mypatds.this_autoscaling_group_id}"
  adjustment_type          = "${var.adjustment_type}"
  comparison_operator      = "${var.comparison_operator}"
  cooldown                 = "${var.cooldown}"
  evaluation_periods       = "${var.evaluation_periods}"
  metric_name              = "${var.metric_name}"
  period                   = "${var.period}"
  scaling_adjustment       = "${var.scaling_adjustment}"
  threshold                = "${var.threshold}"
  treat_missing_data       = "${var.treat_missing_data}"
}

#### Autoscaling Policy for MYPAT API ####
module "asg_policy_mypatapi" {
  source = "git::ssh://git@github.com/opstree-terraform/autoscaling_policy"
  stack_item_fullname      = "${var.stack_name_mypatapi}"
  policy_name              = "${var.policy_name_mypatapi}"
  asg_name                 = "${module.asg_mypatapi.this_autoscaling_group_id}"
  adjustment_type          = "${var.adjustment_type}"
  comparison_operator      = "${var.comparison_operator}"
  cooldown                 = "${var.cooldown}"
  evaluation_periods       = "${var.evaluation_periods}"
  metric_name              = "${var.metric_name}"
  period                   = "${var.period}"
  scaling_adjustment       = "${var.scaling_adjustment}"
  threshold                = "${var.threshold}"
  treat_missing_data       = "${var.treat_missing_data}"
}

#### Autoscaling Policy for CMS DS ####
module "asg_policy_cmsds" {
  source = "git::ssh://git@github.com/opstree-terraform/autoscaling_policy"
  stack_item_fullname      = "${var.stack_name_cmsds}"
  policy_name              = "${var.policy_name_cmsds}"
  asg_name                 = "${module.asg_cmsds.this_autoscaling_group_id}"
  adjustment_type          = "${var.adjustment_type}"
  comparison_operator      = "${var.comparison_operator}"
  cooldown                 = "${var.cooldown}"
  evaluation_periods       = "${var.evaluation_periods}"
  metric_name              = "${var.metric_name}"
  period                   = "${var.period}"
  scaling_adjustment       = "${var.scaling_adjustment}"
  threshold                = "${var.threshold}"
  treat_missing_data       = "${var.treat_missing_data}"
}

#### Autoscaling Policy for CMS API ####
module "asg_policy_cmsapi" {
  source = "git::ssh://git@github.com/opstree-terraform/autoscaling_policy"
  stack_item_fullname      = "${var.stack_name_cmsapi}"
  policy_name              = "${var.policy_name_cmsapi}"
  asg_name                 = "${module.asg_cmsapi.this_autoscaling_group_id}"
  adjustment_type          = "${var.adjustment_type}"
  comparison_operator      = "${var.comparison_operator}"
  cooldown                 = "${var.cooldown}"
  evaluation_periods       = "${var.evaluation_periods}"
  metric_name              = "${var.metric_name}"
  period                   = "${var.period}"
  scaling_adjustment       = "${var.scaling_adjustment}"
  threshold                = "${var.threshold}"
  treat_missing_data       = "${var.treat_missing_data}"
