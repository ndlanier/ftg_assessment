resource "aws_launch_configuration" "ecs_launch_config" {
  name =  "resumeApp-instance"
  image_id = "ami-09db5b31ad3cd145d"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups = [aws_security_group.load_balancer_security_group.id]
  instance_type          = "t2.micro"
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=sonny_cluster >> /etc/ecs/ecs.config"


  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "ecs_asg" {
    name                      = "asg-2"
    vpc_zone_identifier       = data.aws_subnet_ids.public.ids
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name
    target_group_arns = ["${aws_lb_target_group.target_group.arn}"]

    desired_capacity          = 3
    min_size                  = 1
    max_size                  = 5
    health_check_grace_period = 300
    health_check_type         = "EC2"

    tag {
      key = "AmazonECSManaged"
      value = ""
      propagate_at_launch = true
    }
}

resource "aws_ecs_capacity_provider" "capProvider" {
  name = "capProvider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn

    managed_scaling {
      maximum_scaling_step_size = 5
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 3
    }
  }
}

