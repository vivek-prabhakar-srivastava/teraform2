#### Variables for AWS Region ####
variable "aws_region" {
  default = "us-west-2"
}

variable "vpc_name" {
  default = "test"
}

variable "cidr" {
  default = "10.10.0.0/16"
}

variable "route53_zone_name" {
  default = "internal.test.com"
}

#### Variable for SSH Key Pair ####
variable "pub_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

#### Variable for Public Subnet1 ####
variable "pub_sn_aza_cidr" {
  default = "10.10.0.0/20"
}

variable "pub_sn_aza_name" {
  default = "pub_sub_a"
}

#### Variable for Public Subnet2 ####
variable "pub_sn_azb_cidr" {
  default = "10.10.16.0/20"
}

variable "pub_sn_azb_name" {
  default = "pub_sub_b"
}

#### Variable for Private Subnet1 ####
variable "priv_sn_aza_cidr" {
  default = "10.10.32.0/20"
}

variable "priv_sn_aza_name" {
  default = "priv_sub_a"
}

#### Variable for Private Subnet2 ####
variable "priv_sn_azb_cidr" {
  default = "10.10.48.0/20"
}

variable "priv_sn_azb_name" {
  default = "priv_sub_b"
}

#### Variable for DB Private Subnet1 ####
variable "db_sn_aza_cidr" {
  default = "10.10.64.0/20"
}

variable "db_sn_aza_name" {
  default = "db_sn_a"
}

#### Variable for DB Private Subnet2 ####
variable "db_sn_azb_cidr" {
  default = "10.10.80.0/20"
}

variable "db_sn_azb_name" {
  default = "db_sn_b"
}

#### Variables for ALB ####
variable "pub_alb_name" {
  default = "test-alb-pub"
}

#### Variables for DB ALB ####
variable "priv_alb_name" {
  default = "test-alb-priv"
}

#### Variables for Launch Configuration of MYPAT_FRONTEND ####
variable "mypatfe_launch_configuration_name" {
  default = "test-mypatfe"
}

variable "mypatfe_lc_name" {
  default = "lc-mypatfe"
}

variable "image_id" {
    type = "map"
    default = {
      us-east-1 = "ami-66506c1c"
}
}

variable "instance_type" {
  default = "t2.micro"
}

variable  "aws_region_os" {
  default = ""
}

#### Variable for Autoscaling Group ####
variable "key" {
  default = "Environment"
}

variable "value" {
  default = "Dev"
}

#### Variables for MYPAT_FE ####
variable "mypatfe_ami" {
  type = "map"
  default = {
    us-west-2 = ""
  }
}

variable "instance_type_mypatfe" {
  default = "t2.micro"
}

#### Variables for MYPAT_DS ####
variable "mypatds_ami" {
  type = "map"
  default = {
    us-west-2 = ""
  }
}

variable "instance_type_mypatds" {
  default = ""
}

#### Variables for MYPAT_API ####
variable "mypatapi_ami" {
  type = "map"
  default = {
    us-west-2 = ""
  }
}

variable "instance_type_mypatapi" {
  default = "t2.micro"
}

#### Variables for CMS_DS ####
variable "cmsds_ami" {
  type = "map"
  default = {
    us-west-2 = ""
  }
}

variable "instance_type_cmsds" {
  default = "t2.micro"
}

#### Variables for CMS_API ####
variable "cmsapi_ami" {
  type = "map"
  default = {
    us-west-2 = ""
  }
}

variable "instance_type_cmsapi" {
  default = "t2.micro"
}

#### Variables for Launch Configuration of MYPAT_DS ####
variable "mypatds_launch_configuration_name" {
  default = "test-mypatds"
}

variable "mypatds_lc_name" {
  default = "lc-mypatds"
}

#### Variables for Launch Configuration of MYPAT_API ####
variable "mypatapi_launch_configuration_name" {
  default = "test-mypatapi"
}

variable "mypatapi_lc_name" {
  default = "lc-mypatapi"
}

#### Variables for Launch Configuration of MYPAT_API ####
variable "cmsds_launch_configuration_name" {
  default = "test-cmsds"
}

variable "cmsds_lc_name" {
  default = "lc-cmsds"
}

#### Variables for Launch Configuration of MYPAT_API ####
variable "cmsapi_launch_configuration_name" {
  default = "test-cmsapi"
}

variable "cmsapi_lc_name" {
  default = "lc-cmsapi"
}

#### Variables for Autoscaling Policy of MYPAT FRONTEND ####
variable "stack_name_mypatfe" {
  default = "application-mypatfe"
}

variable "policy_name_mypatfe" {
  default = "ops"
}

variable "adjustment_type" {
  default = "PercentChangeInCapacity"
}

variable "comparison_operator" {
  default = "GreaterThanOrEqualToThreshold"
}

variable "cooldown" {
  default = "300"
}

variable "evaluation_periods" {
  default = "2"
}

variable "metric_name" {
  default = "CPUUtilization"
}

variable "period" {
  default = "120"
}

variable "scaling_adjustment" {
  default = "4"
}

variable "threshold" {
  default = "10"
}

variable "treat_missing_data" {
  default = "breaching"
}

#### Variables for Autoscaling Policy of MYPAT DS ####
variable "stack_name_mypatds" { 
  default = "application-mypatds"
}

variable "policy_name_mypatds" {
  default = "ops"
}

#### Variables for Autoscaling Policy of MYPAT API ####
variable "stack_name_mypatapi" {
  default = "application-mypatapi"
}

variable "policy_name_mypatapi" {
  default = "ops"
}

#### Variables for Autoscaling Policy of CMS API ####
variable "stack_name_cmsapi" {
  default = "application-cmsapi"
}

variable "policy_name_cmsapi" {
  default = "ops"
}

#### Variables for Autoscaling Policy of CMS DS ####
variable "stack_name_cmsds" {
  default = "application-cmsds"
}

variable "policy_name_cmsds" {
  default = "ops"
}
