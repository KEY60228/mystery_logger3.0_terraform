# ECSコンテナインスタンス用IAM role
module "ecs_instance_role" {
    source = "./iam_role"
    name = "ecs_instance_role"
    policy = data.aws_iam_policy_document.ecs_instance_policy.json
    identifier = "ec2.amazonaws.com"
}

# ECSコンテナインスタンス用IAM policy
data "aws_iam_policy_document" "ecs_instance_policy" {
    statement {
        effect = "Allow"
        actions = [
            "ecs:CreateCluster",
            "ecs:DeregisterContainerInstance",
            "ecs:DiscoverPollEndpoint",
            "ecs:Poll",
            "ecs:RegisterContainerInstance",
            "ecs:StartTelemetrySession",
            "ecs:UpdateContainerInstancesState",
            "ecs:Submit*",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = [ "*" ]
    }
}

# IAMインスタンスプロファイル
resource "aws_iam_instance_profile" "nazolog_instance_profile" {
    name = "nazolog-instance-profile"
    role = module.ecs_instance_role.iam_role_name
}

# EC2インスタンス用Security Group
# module "ec2_for_ecs_sg" {
#     source = "./security_group"
#     name = "ec2-for-ecs-sg"
#     vpc_id = aws_vpc.nazolog_vpc.id
#     port = 80
#     cidr_blocks = [aws_vpc.nazolog_vpc.cidr_block]
# }

### module security_groupを外出し ###
resource "aws_security_group" "ec2_for_ecs_instance_sg" {
    name = "ec2-for-ecs-instance-sg"
    vpc_id = aws_vpc.nazolog_vpc.id
}

resource "aws_security_group_rule" "ingress" {
    type = "ingress"
    protocol = "-1"
    from_port = 0
    to_port = 0
    source_security_group_id = module.https_sg.security_group_id
    security_group_id = aws_security_group.ec2_for_ecs_instance_sg.id
}

resource "aws_security_group_rule" "egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.ec2_for_ecs_instance_sg.id
}
### module security_groupを外出し ###

# # EC2インスタンス
# resource "aws_instance" "nazolog-ec2-instance" {
#     ami = "ami-0e37e42dff65024ae"
#     instance_type = "t2.micro"
#     monitoring = true
#     iam_instance_profile = aws_iam_instance_profile.nazolog_instance_profile.name
#     subnet_id = aws_subnet.nazolog_public_subnet_1a.id
#     user_data = file("./user_data.sh")
#     associate_public_ip_address = false

#     vpc_security_group_ids = [ module.ec2_for_ecs_sg.security_group_id ]

#     root_block_device {
#         volume_size = "30"
#         volume_type = "gp2"
#     }
# }

# AutoScaling config
resource "aws_launch_template" "nazolog_asg_config" {
    image_id = "ami-0e37e42dff65024ae"
    instance_type = "t2.micro"
    user_data = base64encode(file("./user_data.sh"))

    monitoring {
        enabled = true
    }

    iam_instance_profile {
        arn = aws_iam_instance_profile.nazolog_instance_profile.arn
    }

    network_interfaces {
        associate_public_ip_address = true
        security_groups = [ aws_security_group.ec2_for_ecs_instance_sg.id ]
    }

    block_device_mappings {
        device_name = "/dev/sdf"
        ebs {
            volume_size = 30
            volume_type = "gp2"
        }
    }

    lifecycle {
        create_before_destroy = true
    }
}

# AutoScaling
resource "aws_autoscaling_group" "nazolog_asg" {
    name = "nazolog-asg"
    vpc_zone_identifier = [
        aws_subnet.nazolog_public_subnet_1a.id,
        aws_subnet.nazolog_public_subnet_1c.id,
    ]

    launch_template {
        id = aws_launch_template.nazolog_asg_config.id
        version = aws_launch_template.nazolog_asg_config.latest_version
    }

    min_size = 1
    max_size = 10

    # protect_from_scale_in = true
    protect_from_scale_in = false
}

# AutoScaling用capacity provider
resource "aws_ecs_capacity_provider" "nazolog_capacity_provider" {
    name = "nazolog-capacity_provider"

    auto_scaling_group_provider {
        auto_scaling_group_arn = aws_autoscaling_group.nazolog_asg.arn
        # managed_termination_protection = "ENABLED"
        managed_termination_protection = "DISABLED"

        managed_scaling {
            maximum_scaling_step_size = 100
            minimum_scaling_step_size = 1
            status = "ENABLED"
            target_capacity = 100
        }
    }
}

# ECSタスク実行用IAM role
module "ecs_task_execution_role" {
    source = "./iam_role"
    name = "ecs-task-execution"
    identifier = "ecs-tasks.amazonaws.com"
    policy = data.aws_iam_policy_document.ecs_task_execution.json
}

# AWS管理のTaskExecutionRolePolicyの参照
data "aws_iam_policy" "ecs_task_execution_role_policy" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECSタスク実行用IAM policy
data "aws_iam_policy_document" "ecs_task_execution" {
    source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy

    statement {
        effect = "Allow"
        actions = [
            "ssm:GetParameters",
            "secretmanager:GetSecretValue",
            "kms:Decrypt"
        ]
        resources = [ "*" ]
    }
}

# ECSタスク用IAM role
module "ecs_task_role" {
    source = "./iam_role"
    name = "ecs-task"
    identifier = "ecs-tasks.amazonaws.com"
    policy = data.aws_iam_policy_document.ecs_task.json
}

# ECSタスク用IAM policy
data "aws_iam_policy_document" "ecs_task" {
    statement {
        effect = "Allow"
        actions = [
            "ssm:GetParameters",
            "secretmanager:GetSecretValue",
            "kms:Decrypt",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "ses:SendEmail",
            "ses:SendRawEmail",
            "s3:ListBucket",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:ReplicateObject",
            "s3:DeleteObject",
        ]
        resources = [ "*" ]
    }
}

# ECSクラスタ
resource "aws_ecs_cluster" "nazolog_ecs_cluster" {
    name = "nazolog-ecs-cluster"
    capacity_providers = [ aws_ecs_capacity_provider.nazolog_capacity_provider.name ]

    default_capacity_provider_strategy {
        capacity_provider = aws_ecs_capacity_provider.nazolog_capacity_provider.name
        base = 1
        weight = 1
    }
}

# ECSサービス
resource "aws_ecs_service" "nazolog_ecs_service" {
    name = "nazolog-ecs-service"
    cluster = aws_ecs_cluster.nazolog_ecs_cluster.id
    task_definition = aws_ecs_task_definition.nazolog_ecs_task_definition.arn
    desired_count = 1
    health_check_grace_period_seconds = 60

    capacity_provider_strategy {
        capacity_provider = aws_ecs_capacity_provider.nazolog_capacity_provider.arn
        weight = 1
        base = 1
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.nazolog_alb_target_group.arn
        container_name = "nazolog-nginx"
        container_port = "80"
    }

    lifecycle {
        ignore_changes = [ task_definition ]
    }
}

# タスク定義リソース
resource "aws_ecs_task_definition" "nazolog_ecs_task_definition" {
    family = "nazolog-task"
    cpu = "1024"
    memory = "983"
    container_definitions = file("./container_definitions.json")
    task_role_arn = module.ecs_task_role.iam_role_arn
    execution_role_arn = module.ecs_task_execution_role.iam_role_arn
    network_mode = "bridge"

    volume {
        name = "nazolog"
        docker_volume_configuration {
            scope = "task"
            driver = "local"
        }
    }
}

# デプロイ時にmigrationするタスク
resource "aws_ecs_task_definition" "nazolog_ecs_migrate_task" {
    family = "nazolog-migrate-task"
    cpu = "1024"
    memory = "983"
    container_definitions = file("./migration_task_definitions.json")
    execution_role_arn = module.ecs_task_role.iam_role_arn
    network_mode = "bridge"
}

# ECS Service Auto Scaling設定 (タスクの増減)
resource "aws_appautoscaling_target" "nazolog_ecs_service_autoscaling_target" {
    service_namespace = "ecs"
    resource_id = "service/nazolog-ecs-cluster/nazolog-ecs-service"
    scalable_dimension = "ecs:service:DesiredCount"
    role_arn = data.aws_iam_role.nazolog_ecs_service_autoscaling_role.arn
    min_capacity = 1
    max_capacity = 10

    depends_on = [ aws_ecs_service.nazolog_ecs_service ]
}

# Scale out ポリシー
resource "aws_appautoscaling_policy" "nazolog_ecs_service_autoscaling_out_policy" {
    name = "nazolog-ecs-service-autoscaling-out-policy"
    service_namespace = "ecs"
    resource_id = "service/nazolog-ecs-cluster/nazolog-ecs-service"
    scalable_dimension = "ecs:service:DesiredCount"

    step_scaling_policy_configuration {
        adjustment_type = "ChangeInCapacity"
        cooldown = 600
        metric_aggregation_type = "Average"

        step_adjustment {
            metric_interval_lower_bound = 0
            scaling_adjustment = 1
        }
    }

    depends_on = [ aws_appautoscaling_target.nazolog_ecs_service_autoscaling_target ]
}

# Scale in ポリシー
resource "aws_appautoscaling_policy" "nazolog_ecs_service_autoscaling_in_policy" {
    name = "nazolog-ecs-service-autoscaling-in-policy"
    service_namespace = "ecs"
    resource_id = "service/nazolog-ecs-cluster/nazolog-ecs-service"
    scalable_dimension = "ecs:service:DesiredCount"

    step_scaling_policy_configuration {
        adjustment_type = "ChangeInCapacity"
        cooldown = 600
        metric_aggregation_type = "Average"

        step_adjustment {
            metric_interval_upper_bound = 0
            scaling_adjustment = -1
        }
    }

    depends_on = [ aws_appautoscaling_target.nazolog_ecs_service_autoscaling_target ]
}

# AutoScaling用IAM role
data "aws_iam_role" "nazolog_ecs_service_autoscaling_role" {
    name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
}