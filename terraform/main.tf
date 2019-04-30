# --------------------------------------------------------------------------------------------------
# ECR
# https://github.com/cloudposse/terraform-aws-ecr#readme
# --------------------------------------------------------------------------------------------------

# data "aws_iam_role" "ecr" {
#   name = "ecr"
# }

module "ecr" {
  source          = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=master"
  name            = "${local.app_key}-ci-ecr"
  namespace       = "${var.namespace}"
  stage           = "${var.stage}"
  # roles           = ["${data.aws_iam_role.ecr.name}"]
  max_image_count = "30"
  tags            = "${local.common_tags}"
}

# --------------------------------------------------------------------------------------------------
# ECS Container Definitions
# https://github.com/cloudposse/terraform-aws-ecs-container-definition#readme
# --------------------------------------------------------------------------------------------------

module "container" {
  source           = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=master"
  container_name   = "${local.app_key}"
  container_image  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${local.aws_default_region}.amazonaws.com/${module.ecr.repository_name}:${var.app_version_label}"
  container_memory = "${var.app_ecs_memory}"
  port_mappings    = [
    {
      containerPort = "${var.app_ecs_container_port}"
      hostPort      = "${var.app_ecs_host_port}"
      protocol      = "tcp"
    },
  ]
  environment = [
    {
      name  = "ENV"
      value = "${var.env}"
    },
    {
      name  = "NODE_ENV"
      value = "${var.env}"
    },
  ]
}

# --------------------------------------------------------------------------------------------------
# S3
# https://github.com/cloudposse/terraform-aws-s3-bucket#readme
# --------------------------------------------------------------------------------------------------

module "s3_bucket" {
  source        = "git::https://github.com/cloudposse/terraform-aws-s3-bucket.git?ref=master"
  enabled       = "true"
  force_destroy = "true"
  name          = "${local.app_key}-ci-bucket"
  stage         = "${var.stage}"
  namespace     = "${var.namespace}"
  tags          = "${local.common_tags}"
}

# --------------------------------------------------------------------------------------------------
# VPC
# https://github.com/cloudposse/terraform-aws-vpc#readme
# --------------------------------------------------------------------------------------------------

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${local.app_key}-vpc"
  cidr_block = "10.0.0.0/16"
}

# --------------------------------------------------------------------------------------------------
# Subnets
# https://github.com/cloudposse/terraform-aws-dynamic-subnets#readme
# --------------------------------------------------------------------------------------------------

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  availability_zones  = ["${slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)}"]
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "${local.app_key}-subnets"
  region              = "${data.aws_region.current.name}"
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"
  cidr_block          = "${module.vpc.vpc_cidr_block}"
  nat_gateway_enabled = "true"
}

# --------------------------------------------------------------------------------------------------
# Beanstalk Application
# https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application#readme
# --------------------------------------------------------------------------------------------------

module "elastic_beanstalk_application" {
  source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application.git?ref=master"
  namespace   = "${var.namespace}"
  stage       = "${var.stage}"
  name        = "${var.app_name}"
  description = "${var.app_description}"
  tags        = "${local.common_env_tags}"
}

resource "null_resource" "elastic_beanstalk_application_version" {
  triggers = {
    app_version_label = "${var.app_version_label}"
    container_json    = "${module.container.json}"
    bucket_id         = "${module.s3_bucket.bucket_id}"
    app_name          = "${module.elastic_beanstalk_application.app_name}"
  }
  provisioner "local-exec" {
    working_dir = "${var.build_path}"
    command     = "docker build -t $AWS_ECR_IMAGE_URL . || exit; $(aws ecr get-login --no-include-email --region $AWS_DEFAULT_REGION) || exit; docker push $AWS_ECR_IMAGE_URL || exit; docker rmi -f $AWS_ECR_IMAGE_URL < /dev/null 2> /dev/null;"
    environment = {
      AWS_DEFAULT_REGION = "${local.aws_default_region}"
      AWS_ECR_IMAGE_URL  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${local.aws_default_region}.amazonaws.com/${module.ecr.repository_name}:${var.app_version_label}"
    }
  }
  provisioner "local-exec" {
    working_dir = "${var.temp_path}"
    command     = "echo $CONTAINER_JSON > $CONTAINER_JSON_FILE || exit; zip -rv $ZIP_PATH $CONTAINER_JSON_FILE || exit;"
    environment = {
      CONTAINER_JSON      = "${module.container.json}"
      CONTAINER_JSON_FILE = "Dockerrun.aws.json"
      ZIP_PATH            = "${var.temp_path}/${var.app_ci_s3_uri}"
    }
  }
  provisioner "local-exec" {
    working_dir = "${var.temp_path}"
    command     = "aws s3 cp $ZIP_PATH $AWS_S3_PATH || exit;"
    environment = {
      ZIP_PATH    = "${var.temp_path}/${var.app_ci_s3_uri}"
      AWS_S3_PATH = "s3://${module.s3_bucket.bucket_id}/${var.app_ci_s3_uri}"
    }
  }
  provisioner "local-exec" {
    command     = "aws elasticbeanstalk create-application-version --application-name $APP_NAME --version-label $APP_VERSION_LABEL --description $APP_VERSION_LABEL --source-bundle $SOURCE_BUNDLE || exit;"
    environment = {
      APP_NAME          = "${module.elastic_beanstalk_application.app_name}"
      APP_VERSION_LABEL = "${var.app_version_label}"
      SOURCE_BUNDLE     = "S3Bucket=\"${module.s3_bucket.bucket_id}\",S3Key=\"${var.app_ci_s3_uri}\""
    }
  }
}

# --------------------------------------------------------------------------------------------------
# Beanstalk Application Environment
# https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment#readme
# --------------------------------------------------------------------------------------------------

module "elastic_beanstalk_environment" {
  source    = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=master"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${local.app_env_key}"
  app       = "${module.elastic_beanstalk_application.app_name}"

  application_port        = "${var.app_ecs_host_port}"
  autoscale_max           = "${var.aws_autoscaling_asg__MaxSize}"
  autoscale_min           = "${var.aws_autoscaling_asg__MinSize}"
  description             = "${var.app_description}"
  healthcheck_url         = "${var.aws_elasticbeanstalk__Application_Healthcheck_URL}"
  http_listener_enabled   = "true"
  instance_type           = "${local.aws_autoscaling_launchconfiguration__InstanceType}"
  keypair                 = ""
  loadbalancer_type       = "application"
  private_subnets         = "${module.subnets.private_subnet_ids}"
  public_subnets          = "${module.subnets.public_subnet_ids}"
  security_groups         = ["${module.vpc.vpc_default_security_group_id}"]
  solution_stack_name     = "${local.aws_elastic_beanstalk_environment__solution_stack_name}"
  tags                    = "${local.common_env_tags}"
  updating_max_batch      = "${var.aws_autoscaling_updatepolicy_rollingupdate__MaxBatchSize}"
  updating_min_in_service = 0
  # version_label           = "${var.app_version_label}"
  vpc_id                  = "${module.vpc.vpc_id}"
}

# resource "null_resource" "elastic_beanstalk_environment" {
#   triggers = {
#     app_version_label = "${var.app_version_label}"
#     container_json    = "${module.container.json}"
#     app_name          = "${module.elastic_beanstalk_application.app_name}"
#     app_env_name      = "${module.elastic_beanstalk_environment.name}"
#   }
#   provisioner "local-exec" {
#     command     = "aws elasticbeanstalk update-environment --application-name $APP_NAME --version-label $APP_VERSION_LABEL --environment-name $APP_NAME_ENV || exit;"
#     environment = {
#       APP_NAME          = "${module.elastic_beanstalk_application.app_name}"
#       APP_VERSION_LABEL = "${var.app_version_label}"
#       APP_NAME_ENV      = "${module.elastic_beanstalk_environment.name}"
#     }
#   }
# }
