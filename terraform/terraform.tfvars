# --------------------------------------------------------------------------------------------------
# Primary/Required Variables
# --------------------------------------------------------------------------------------------------

# Set shorthand region key for use in resource naming and tagging.
aws_region_key = "${var.aws_region_keys["${data.aws_region.current}"]}"

# VPC, Subnet and ELB
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-ec2vpc
# aws_ec2_vpc__VPCId                    = "${local.aws_ec2_vpc__VPCId}"
aws_ec2_vpc__AssociatePublicIpAddress = "true"
# aws_ec2_vpc__Subnets                  = "${local.aws_ec2_vpc__Subnets}"
# aws_ec2_vpc__ELBSubnets               = "${local.aws_ec2_vpc__ELBSubnets}"
aws_ec2_vpc__ELBScheme                = "public"

# Elastic Beanstalk

# Provides an Elastic Beanstalk Application Resource.
# https://www.terraform.io/docs/providers/aws/r/elastic_beanstalk_application.html
# aws_elastic_beanstalk_application__name        = "${local.aws_elastic_beanstalk_application__name}"
# aws_elastic_beanstalk_application__description = "${local.aws_elastic_beanstalk_application__description}"

# Provides an Elastic Beanstalk Environment Resource.
# https://www.terraform.io/docs/providers/aws/r/elastic_beanstalk_environment.html
# aws_elastic_beanstalk_environment__name                   = "${local.aws_elastic_beanstalk_environment__name}"
# aws_elastic_beanstalk_environment__description            = "${local.aws_elastic_beanstalk_environment__description}"
# aws_elastic_beanstalk_environment__solution_stack_name    = "${local.aws_elastic_beanstalk_environment__solution_stack_name}"
# aws_elastic_beanstalk_environment__tier                   = "WebServer"
# aws_elastic_beanstalk_environment__cname_prefix           = ""
# aws_elastic_beanstalk_environment__wait_for_ready_timeout = "20m"
# aws_elastic_beanstalk_environment__version_label          = "latest"

# Configure your environment's architecture and service role.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkenvironment
# aws_elasticbeanstalk_environment__ServiceRole     = "aws-elasticbeanstalk-service-role"
# aws_elasticbeanstalk_environment__EnvironmentType = "LoadBalanced"

# Configure a health check path for your application.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkapplication
aws_elasticbeanstalk__Application_Healthcheck_URL = "/health"

# Rolling Updates For Deployments
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkcommand
aws_elasticbeanstalk_command__DeploymentPolicy  = "Rolling"     // *AllAtOnce | Rolling | RollingWithAdditionalBatch | Immutable
aws_elasticbeanstalk_command__Timeout           = "600"         // *600 | "1" to "3600"
aws_elasticbeanstalk_command__BatchSizeType     = "Percentage"  // *Percentage | Fixed
aws_elasticbeanstalk_command__BatchSize         = "50"          // *100 | 1 to 100 (Percentage) | 1 to aws:autoscaling:asg::MaxSize (Fixed)
aws_elasticbeanstalk_command__IgnoreHealthCheck = "false"       // true | *false

# Configure rolling updates your environment's Auto Scaling group.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingupdatepolicyrollingupdate
# aws_autoscaling_updatepolicy_rollingupdate__MaxBatchSize         = "1"
# aws_autoscaling_updatepolicy_rollingupdate__RollingUpdateEnabled = "true"
# aws_autoscaling_updatepolicy_rollingupdate__RollingUpdateType    = "Health"

# ELB Config

# Configure healthchecks for a classic load balancer.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elbhealthcheck
# aws_elb_healthcheck__Interval               = "5"
# aws_elb_healthcheck__Timeout                = "2"
# aws_elb_healthcheck__UnhealthyThreshold     = "2"
# Configure the default listener (port 80) on a classic load balancer.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elblistener
aws_elb_listener__InstancePort              = "80"
# Configure your environment's classic load balancer.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elbloadbalancer
# aws_elb_loadbalancer__CrossZone             = "true"
# aws_elb_loadbalancer__ManagedSecurityGroup  = "sg-12345678"
# aws_elb_loadbalancer__SecurityGroups        = "sg-12345678"
# Modify the default stickiness and global load balancer policies for a classic load balancer.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elbpolicies
# aws_elb_policies__ConnectionDrainingEnabled = "true"
# aws_elb_policies__ConnectionDrainingTimeout = "300"

# Configure your environment's EC2 instances.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalinglaunchconfiguration
# aws_autoscaling_launchconfiguration__SecurityGroups      = "sg-12345678,sg-12345678"
# aws_autoscaling_launchconfiguration__IamInstanceProfile  = "aws-elasticbeanstalk-ec2-role"
# aws_autoscaling_launchconfiguration__InstanceType        = "t3.small"
# aws_autoscaling_launchconfiguration__ImageId             = "ami-0bc08634af113cccb"
# aws_autoscaling_launchconfiguration__EC2KeyName          = ""
# aws_autoscaling_launchconfiguration__BlockDeviceMappings = ""
# aws_autoscaling_launchconfiguration__RootVolumeSize      = ""
# aws_autoscaling_launchconfiguration__RootVolumeType      = ""

# Configure your environment's Auto Scaling group.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingasg
# aws_autoscaling_asg__Availability_Zones = "Any 3"
# aws_autoscaling_asg__MinSize            = "1"
# aws_autoscaling_asg__MaxSize            = "4"

# Configure scaling triggers for your environment's Auto Scaling group.
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingtrigger
# aws_autoscaling_trigger__MeasureName               = "CPUUtilization"  // NetworkIn | *NetworkOut | RequestCount | HealthyHostCount | UnHealthyHostCount
# aws_autoscaling_trigger__Statistic                 = "Average"         // *Average | Minimum | Maximum | Sum
# aws_autoscaling_trigger__Unit                      = "Percent"         // Percent | Seconds | *Bytes | Bits | Count
# aws_autoscaling_trigger__Period                    = "5"               // minutes between metric evaluations
# aws_autoscaling_trigger__BreachDuration            = "3"               // minutes a metric can exceed threshold to trigger scaling
# aws_autoscaling_trigger__EvaluationPeriods         = "1"               // maximum evaluations during breach period?
# aws_autoscaling_trigger__UpperThreshold            = "65"              // metric exceeding this number triggers scale-up
# aws_autoscaling_trigger__UpperBreachScaleIncrement = "1"               // 1 = scale-up one at a time
# aws_autoscaling_trigger__LowerThreshold            = "50"              // metric below this number triggers scale-down
# aws_autoscaling_trigger__LowerBreachScaleIncrement = "-1"              // -1 = scale-down one at a time
