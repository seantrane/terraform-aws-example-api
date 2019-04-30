# --------------------------------------------------------------------------------------------------
# Primary/Required Variables
# --------------------------------------------------------------------------------------------------

variable "env" {
  description = "Environment, e.g.; DEV | UAT | PROD"
  default = "PROD"
}
variable "stage" {
  description = "Stage, e.g.; 'prod', 'staging', 'dev', or 'test'"
  default = "prod"
}

variable "build_path" {
  description = "Path of image build directory (containing Dockerfile), e.g.; '/path/to/build'"
  default = "build"
}

variable "temp_path" {
  description = "Path of temp directory, e.g.; '/path/to/temp'"
  default = "temp"
}

variable "namespace" {
  description = "Namespace, which could be your organization name, e.g.; 'abc'"
}
variable "app_name" {
  description = "Truncated/short name of application (ex; auth, preferences, search, ...)"
}
variable "app_author" {
  description = "Author/Team name (ex; Jane Doe, Customer Engagement, ...)"
}
variable "app_origin" {
  description = "Origin code repository, (ex; <user>/<repo>, <org>/<repo>, ...)"
}
variable "app_category" {
  description = "Business/Platform Domain or Application Category (ex; Core, Users, Orders, ...)"
}
variable "app_title" {
  description = "Short title of application (ex; Auth, Preferences, Search, ...)"
}
variable "app_service" {
  description = "Truncated/short [micro-]service name (ex; agent, api, dashboard, website, ...)"
}
variable "app_description" {
  description = "What does the service/resource do?"
}

variable "app_version_label" {
  description = "App name and version, as a tag, e.g.; 'latest' or 'app-name-v1.2.3-20190131'"
  default = "latest"
}

variable "app_ci_s3_uri" {
  description = "App name and version, as a filename, e.g.; 'latest' or 'app-name-v1.2.3-20190131.zip'"
  default = "latest.zip"
}

variable "app_ecs_memory" {
  description = "ECS container memory, e.g.; '256'"
  default = "256"
}

variable "app_ecs_container_port" {
  description = "ECS container port, e.g.; '80'"
  default = "80"
}

variable "app_ecs_host_port" {
  description = "EC2 instance port, e.g.; '80'"
  default = "80"
}

# --------------------------------------------------------------------------------------------------
# Defaults
# --------------------------------------------------------------------------------------------------

variable "aws_region_keys" {
  description = "Array of region keys and their respective shorthand values."
  default     = {
    "us-east-1"      = "use1"   // Northern Virginia
    "us-west-2"      = "usw2"   // Oregon
    "eu-west-1"      = "euw1"   // Ireland
    "eu-central-1"   = "euc1"   // Frankfurt
    "ap-northeast-1" = "apne1"  // Tokyo
    "ap-southeast-1" = "apse1"  // Singapore
    "ap-southeast-2" = "apse2"  // Sydney
  }
}
variable "aws_region_key" {
  description = "Shorthand region key for use in resource naming and tagging."
  default = "use1"
}

# https://ec2instances.info/?cost_duration=monthly&selected=t3.micro,t3.small,a1.medium,t3.medium,a1.large,m5a.large,a1.xlarge,r5a.large,m5a.xlarge,r5a.xlarge,i3.xlarge,m5a.2xlarge,r5a.2xlarge,i3.2xlarge
variable "default_InstanceTypes" {
  type = "map"
  default = {
    dev  = "t3.micro"
    uat  = "t3.micro"
    prod = "t3.micro"
  }
}

variable "default_ImageIds" {
  type = "map"
  default = {
    "us-east-1"      = "ami-0bc08634af113cccb"  // Northern Virginia
    "us-west-2"      = "ami-0054160a688deeb6a"  // Oregon
    "eu-west-1"      = "ami-09cd8db92c6bf3a84"  // Ireland
    "eu-central-1"   = "ami-0ab1db011871746ef"  // Frankfurt
    "ap-northeast-1" = "ami-00f839709b07ffb58"  // Tokyo
    "ap-southeast-1" = "ami-0c5b69a05af2f0e23"  // Singapore
    "ap-southeast-2" = "ami-011ce3fbe73731dfe"  // Sydney
  }
}

# --------------------------------------------------------------------------------------------------
# VPC, Subnet and ELB
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-ec2vpc
# --------------------------------------------------------------------------------------------------

variable "max_availability_zones" {
  default = "2"
}

variable "aws_ec2_vpc__VPCId" {
  description = "The ID for your Amazon VPC."
  default = ""
}
variable "aws_ec2_vpc__AssociatePublicIpAddress" {
  description = "Specifies whether to launch instances with public IP addresses in your Amazon VPC. Instances with public IP addresses do not require a NAT device to communicate with the Internet. You must set the value to true if you want to include your load balancer and instances in a single public subnet."
  default = "false"
}
variable "aws_ec2_vpc__Subnets" {
  description = "The IDs of the Auto Scaling group subnet or subnets. If you have multiple subnets, specify the value as a single comma-delimited string of subnet IDs (for example, 'subnet-11111111,subnet-22222222')."
  default = ""
}
variable "aws_ec2_vpc__ELBSubnets" {
  description = "The IDs of the subnet or subnets for the elastic load balancer. If you have multiple subnets, specify the value as a single comma-delimited string of subnet IDs (for example, 'subnet-11111111,subnet-22222222')."
  default = ""
}
variable "aws_ec2_vpc__ELBScheme" {
  description = "Specify internal if you want to create an internal load balancer in your Amazon VPC so that your Elastic Beanstalk application cannot be accessed from outside your Amazon VPC. If you specify a value other than public or internal, Elastic Beanstalk will ignore the value."
  default = "internal"
}

# --------------------------------------------------------------------------------------------------
# Provides an Elastic Beanstalk Application Resource.
# https://www.terraform.io/docs/providers/aws/r/elastic_beanstalk_application.html
# --------------------------------------------------------------------------------------------------

variable "aws_elastic_beanstalk_application__name" {
  description = "(Required) The name of the application, must be unique within your account."
  default = ""
}
variable "aws_elastic_beanstalk_application__description" {
  description = "(Optional) Short description of the application."
  default = ""
}

# --------------------------------------------------------------------------------------------------
# Provides an Elastic Beanstalk Environment Resource.
# https://www.terraform.io/docs/providers/aws/r/elastic_beanstalk_environment.html
# --------------------------------------------------------------------------------------------------

variable "aws_elastic_beanstalk_environment__name" {
  description = "(Required) A unique name for this Environment. This name is used in the application URL."
  default = ""
}
variable "aws_elastic_beanstalk_environment__description" {
  description = "(Required) Name of the application that contains the version to be deployed."
  default = ""
}
variable "aws_elastic_beanstalk_environment__solution_stack_name" {
  description = "(Optional) A solution stack to base your environment off of."
  default = "64bit Amazon Linux 2018.03 v2.12.0 running Multi-container Docker 18.06.1-ce (Generic)"
}
variable "aws_elastic_beanstalk_environment__tier" {
  description = "(Optional) Elastic Beanstalk Environment tier. Values; Worker | *WebServer"
  default = "WebServer"
}
variable "aws_elastic_beanstalk_environment__cname_prefix" {
  description = "(Optional) Prefix to use for the fully qualified DNS name of the Environment."
  default = ""
}
variable "aws_elastic_beanstalk_environment__wait_for_ready_timeout" {
  description = "(Default: 20m) The maximum duration that Terraform should wait for an Elastic Beanstalk Environment to be in a ready state before timing out."
  default = "20m"
}
variable "aws_elastic_beanstalk_environment__version_label" {
  description = "(Optional) The name of the Elastic Beanstalk Application Version to use in deployment."
  default = "latest"
}
# Configure your environment's architecture and service role.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkenvironment
variable "aws_elasticbeanstalk_environment__ServiceRole" {
  description = "The name of an IAM role that Elastic Beanstalk uses to manage resources for the environment. Specify a role name (optionally prefixed with a custom path) or its ARN."
  default = ""
}
variable "aws_elasticbeanstalk_environment__EnvironmentType" {
  description = "Set to SingleInstance to launch one EC2 instance with no load balancer. Values; *LoadBalanced | SingleInstance"
  default = "LoadBalanced"
}

# Configure a health check path for your application.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkapplication
variable "aws_elasticbeanstalk__Application_Healthcheck_URL" {
  description = "The path to which to send health check requests. If not set, the load balancer attempts to make a TCP connection on port 80 to verify health. Set to a path starting with / to send an HTTP GET request to that path. You can also include a protocol (HTTP, HTTPS, TCP, or SSL) and port prior to the path to check HTTPS connectivity or use a non-default port. Values; / (HTTP GET to root path), /health, HTTPS:443/, HTTPS:443/health"
  default = "8200/health"
}

# --------------------------------------------------------------------------------------------------
# Configure rolling deployments for your application code.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkcommand
# --------------------------------------------------------------------------------------------------

variable "aws_elasticbeanstalk_command__DeploymentPolicy" {
  description = "Choose a deployment policy for application version deployments. Values; *AllAtOnce | Rolling | RollingWithAdditionalBatch | Immutable"
  default = "Rolling"
}
variable "aws_elasticbeanstalk_command__Timeout" {
  description = "Number of seconds to wait for an instance to complete executing commands. Values; *600 | 1 to 3600"
  default = "600"
}
variable "aws_elasticbeanstalk_command__BatchSizeType" {
  description = "The type of number that is specified in BatchSize. Values; *Percentage | Fixed"
  default = "Percentage"
}
variable "aws_elasticbeanstalk_command__BatchSize" {
  description = "Percentage or fixed number of Amazon EC2 instances in the Auto Scaling group on which to simultaneously perform deployments. Valid values vary per BatchSizeType setting. Values; *100 | 1 to 100 (Percentage) | 1 to aws:autoscaling:asg::MaxSize (Fixed)"
  default = "50"
}
variable "aws_elasticbeanstalk_command__IgnoreHealthCheck" {
  description = "Do not cancel a deployment due to failed health checks. Values; *false	| true"
  default = "false"
}

# --------------------------------------------------------------------------------------------------
# Configure rolling updates your environment's Auto Scaling group.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingupdatepolicyrollingupdate
# --------------------------------------------------------------------------------------------------

variable "aws_autoscaling_updatepolicy_rollingupdate__MaxBatchSize" {
  description = "The number of instances included in each batch of the rolling update. Default is one-third of the minimum size of the autoscaling group, rounded to the next highest integer. Values; 1 to 10000"
  default = "1"
}
variable "aws_autoscaling_updatepolicy_rollingupdate__RollingUpdateEnabled" {
  description = "If true, enables rolling updates for an environment. Rolling updates are useful when you need to make small, frequent updates to your Elastic Beanstalk software application and you want to avoid application downtime. Setting this value to true automatically enables the MaxBatchSize, MinInstancesInService, and PauseTime options. Setting any of those options also automatically sets the RollingUpdateEnabled option value to true. Setting this option to false disables rolling updates."
  default = "true"
}
variable "aws_autoscaling_updatepolicy_rollingupdate__RollingUpdateType" {
  description = "Time-based rolling updates apply a PauseTime between batches. Health-based rolling updates wait for new instances to pass health checks before moving on to the next batch. Immutable updates launch a full set of instances in a new AutoScaling group. Values; *Time | Health | Immutable"
  default = "Health"
}

# --------------------------------------------------------------------------------------------------
# ELB Config
# --------------------------------------------------------------------------------------------------

# Configure the default listener (port 80) on a classic load balancer.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elblistener
variable "aws_elb_listener__InstancePort" {
  description = "The port that this listener uses to communicate with the EC2 instances. Default value is the same as `listener_port`. Values; 1 to 65535"
  default = "8200"
}
# Configure healthchecks for a classic load balancer.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elbhealthcheck
variable "aws_elb_healthcheck__Interval" {
  description = "The interval at which Elastic Load Balancing will check the health of your application's Amazon EC2 instances. Values; *10 | 5 to 300"
  default = "5"
}
variable "aws_elb_healthcheck__Timeout" {
  description = "Number of seconds Elastic Load Balancing will wait for a response before it considers the instance nonresponsive. Values; *5 | 2 to 60"
  default = "2"
}
variable "aws_elb_healthcheck__UnhealthyThreshold" {
  description = "Consecutive unsuccessful requests before Elastic Load Balancing changes the instance health status. Values; *5 | 2 to 10"
  default = "2"
}
# Configure your environment's classic load balancer.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elbloadbalancer
variable "aws_elb_loadbalancer__CrossZone" {
  description = "Configure the load balancer to route traffic evenly across all instances in all Availability Zones rather than only within each zone. Values; *False | True"
  default = "true"
}
variable "aws_elb_loadbalancer__ManagedSecurityGroup" {
  description = "Assign an existing security group to your environment's load balancer, instead of creating a new one. To use this setting, update the SecurityGroups setting in this namespace to include your security group's ID, and remove the automatically created security group's ID, if one exists."
  default = ""
}
variable "aws_elb_loadbalancer__SecurityGroups" {
  description = "Assign one or more security groups that you created to the load balancer."
  default = ""
}
# Modify the default stickiness and global load balancer policies for a classic load balancer.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elbpolicies
variable "aws_elb_policies__ConnectionDrainingEnabled" {
  description = "Specifies whether the load balancer maintains existing connections to instances that have become unhealthy or deregistered to complete in-progress requests. Values; *False | True"
  default = "true"
}
variable "aws_elb_policies__ConnectionDrainingTimeout" {
  description = "The maximum number of seconds that the load balancer maintains existing connections to an instance during connection draining before forcibly closing the connections. Values; *20 | 1 to 3600"
  default = "300"
}

# --------------------------------------------------------------------------------------------------
# Configure your environment's EC2 instances.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalinglaunchconfiguration
# --------------------------------------------------------------------------------------------------

variable "aws_autoscaling_launchconfiguration__SecurityGroups" {
  description = "Lists the Amazon EC2 security groups to assign to the EC2 instances in the Auto Scaling group in order to define firewall rules for the instances."
  default = ""
}
variable "aws_autoscaling_launchconfiguration__IamInstanceProfile" {
  description = "An instance profile enables AWS Identity and Access Management (IAM) users and AWS services to access temporary security credentials to make AWS API calls. Specify the instance profile's name or its ARN."
  default = ""
}
variable "aws_autoscaling_launchconfiguration__InstanceType" {
  description = "The instance type used to run your application in an Elastic Beanstalk environment. The instance types available depend on platform, solution stack (configuration) and region."
  default = ""
}
variable "aws_autoscaling_launchconfiguration__ImageId" {
  description = "You can override the default Amazon Machine Image (AMI) by specifying your own custom AMI ID."
  default = ""
}
variable "aws_autoscaling_launchconfiguration__EC2KeyName" {
  description = "A key pair enables you to securely log into your EC2 instance."
  default = ""
}
# variable "aws_autoscaling_launchconfiguration__BlockDeviceMappings" {
#   description = "Attach additional Amazon EBS volumes or instance store volumes on all of the instances in the autoscaling group."
#   default = ""
# }
# variable "aws_autoscaling_launchconfiguration__RootVolumeSize" {
#   description = "Storage capacity of the root Amazon EBS volume in whole GB. Required if you set RootVolumeType to provisioned IOPS SSD."
#   default = ""
# }
# variable "aws_autoscaling_launchconfiguration__RootVolumeType" {
#   description = "Volume type (magnetic, general purpose SSD or provisioned IOPS SSD) to use for the root Amazon EBS volume attached to your environment's EC2 instances."
#   default = "gp2"
# }

# --------------------------------------------------------------------------------------------------
# Configure your environment's Auto Scaling group.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingasg
# --------------------------------------------------------------------------------------------------

variable "aws_autoscaling_asg__Availability_Zones" {
  description = "Availability Zones (AZs) are distinct locations within a region that are engineered to be isolated from failures in other AZs and provide inexpensive, low-latency network connectivity to other AZs in the same region. Choose the number of AZs for your instances. Values; *Any | Any 1 | Any 2 | Any 3"
  default = "Any 3"
}
variable "aws_autoscaling_asg__MinSize" {
  description = "Minimum number of instances you want in your Auto Scaling group. Values; *1 | 1 to 10000"
  default = "1"
}
variable "aws_autoscaling_asg__MaxSize" {
  description = "Maximum number of instances you want in your Auto Scaling group. Values; *4 | 1 to 10000"
  default = "4"
}

# --------------------------------------------------------------------------------------------------
# Configure scaling triggers for your environment's Auto Scaling group.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingtrigger
# --------------------------------------------------------------------------------------------------

variable "aws_autoscaling_trigger__MeasureName" {
  description = "Metric used for your Auto Scaling trigger. Values; CPUUtilization | NetworkIn | *NetworkOut | RequestCount | HealthyHostCount | UnHealthyHostCount"
  default = "CPUUtilization"
}
variable "aws_autoscaling_trigger__Statistic" {
  description = "Statistic the trigger should use. Values; *Average | Minimum | Maximum | Sum"
  default = "Average"
}
variable "aws_autoscaling_trigger__Unit" {
  description = "Unit for the trigger measurement. Values; Percent | Seconds | *Bytes | Bits | Count"
  default = "Percent"
}
variable "aws_autoscaling_trigger__Period" {
  description = "Specifies how frequently Amazon CloudWatch measures the metrics for your trigger. The value is the number of minutes between two consecutive periods (minutes between metric evaluations). Values; *5 | 1 to 600"
  default = "5"
}
variable "aws_autoscaling_trigger__BreachDuration" {
  description = "Amount of time, in minutes, a metric can be beyond its defined limit (as specified in the UpperThreshold and LowerThreshold) before the trigger fires. Values; *5 | 1 to 600"
  default = "3"
}
variable "aws_autoscaling_trigger__EvaluationPeriods" {
  description = "The number of consecutive evaluation periods used to determine if a breach is occurring (maximum evaluations during breach period). Values; *1 | 1 to 600"
  default = "1"
}
variable "aws_autoscaling_trigger__UpperThreshold" {
  description = "If the measurement is higher than this number for the breach duration, a trigger is fired (metric exceeding this number triggers scale-up). Values; *6000000 | 0 to 20000000"
  default = "80"
}
variable "aws_autoscaling_trigger__UpperBreachScaleIncrement" {
  description = "How many Amazon EC2 instances to add when performing a scaling activity. Values; 1 = scale-up one instance at a time"
  default = "1"
}
variable "aws_autoscaling_trigger__LowerThreshold" {
  description = "If the measurement falls below this number for the breach duration, a trigger is fired (metric below this number triggers scale-down). Values; *2000000 | 0 to 20000000"
  default = "50"
}
variable "aws_autoscaling_trigger__LowerBreachScaleIncrement" {
  description = "How many Amazon EC2 instances to remove when performing a scaling activity. Values; -1 = scale-down one instance at a time"
  default = "-1"
}

