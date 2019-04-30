# --------------------------------------------------------------------------------------------------
# AWS Account ID, User ID, and ARN
# https://www.terraform.io/docs/providers/aws/d/caller_identity.html
# --------------------------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

# --------------------------------------------------------------------------------------------------
# AWS Region
# https://www.terraform.io/docs/providers/aws/d/region.html
# https://docs.aws.amazon.com/general/latest/gr/rande.html
# https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/
# --------------------------------------------------------------------------------------------------
data "aws_region" "current" {}

variable "aws_default_region" {
  default = ""
}

variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  version = "~> 2.6"
  # region = "${var.aws_region}"
}

# --------------------------------------------------------------------------------------------------
# AWS VPC
# https://www.terraform.io/docs/providers/aws/d/vpc.html
# --------------------------------------------------------------------------------------------------

# variable "vpc_id" {
#   description = "The ID for your Amazon VPC."
# }

# data "aws_vpc" "selected" {
#   id = "${var.vpc_id}"
# }

# --------------------------------------------------------------------------------------------------
# AWS Subnets
# https://www.terraform.io/docs/providers/aws/d/subnet_ids.html
# --------------------------------------------------------------------------------------------------
# data "aws_subnet_ids" "selected" {
#   vpc_id = "${data.aws_vpc.selected.id}"
# }

# --------------------------------------------------------------------------------------------------
# AWS Availability Zones
# https://www.terraform.io/docs/providers/aws/d/availability_zones.html
# --------------------------------------------------------------------------------------------------
data "aws_availability_zones" "available" {}

# --------------------------------------------------------------------------------------------------
# AWS AMI's
# https://www.terraform.io/docs/providers/aws/d/ami.html
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
# --------------------------------------------------------------------------------------------------

# Find the latest available AMI that is ECS-optimized Amazon Linux 2 for EBS
# data "aws_ami" "amzn2_ecs_ebs" {
#   most_recent = true
#   # name_regex  = "^amzn2-ami-ecs-hvm-2\\.0\\.\\d{8}-x86_64-ebs"
#   owners      = ["self"]

#   filter {
#     name   = "state"
#     values = ["available"]
#   }

#   filter {
#     name = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name = "architecture"
#     values = ["x86_64"]
#   }

#   filter {
#     name = "root-device-type"
#     values = ["ebs"]
#   }
# }

# Find the latest available ARM64 AMI that is ECS-optimized Amazon Linux 2 for EBS
# data "aws_ami" "amzn2_ecs_ebs_arm64" {
#   most_recent = true
#   # name_regex  = "^amzn2-ami-ecs-hvm-2\\.0\\.\\d{8}-arm64-ebs"
#   owners      = ["self"]

#   filter {
#     name   = "state"
#     values = ["available"]
#   }

#   filter {
#     name = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name = "architecture"
#     values = ["arm64"]
#   }

#   filter {
#     name = "root-device-type"
#     values = ["ebs"]
#   }
# }

# --------------------------------------------------------------------------------------------------
# AWS Elastic Beanstalk Solution Stacks
# https://www.terraform.io/docs/providers/aws/d/elastic_beanstalk_solution_stack.html
# https://docs.aws.amazon.com/cli/latest/reference/elasticbeanstalk/list-available-solution-stacks.html
# --------------------------------------------------------------------------------------------------

data "aws_elastic_beanstalk_solution_stack" "multi_docker" {
  most_recent = true
  name_regex = "^64bit Amazon Linux (.*) Multi-container Docker (.*)$"
}
