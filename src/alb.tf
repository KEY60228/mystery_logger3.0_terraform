# HTTPリダイレクトのためのセキュリティグループ
module "http_redirect_sg" {
    source = "./security_group"
    name = "http-redirect-sg"
    vpc_id = aws_vpc.nazolog_vpc.id
    port = 80
    cidr_blocks = ["0.0.0.0/0"]
}

# HTTPSアクセスのためのセキュリティグループ
module "https_sg" {
    source = "./security_group"
    name = "https-sg"
    vpc_id = aws_vpc.nazolog_vpc.id
    port = 443
    cidr_blocks = ["0.0.0.0/0"]
}

# ALBリソース
resource "aws_lb" "nazolog_alb" {
    name = "nazolog-alb"
    load_balancer_type = "application"
    internal = false
    idle_timeout = 60
    enable_deletion_protection = true

    subnets = [
        aws_subnet.nazolog_public_subnet_1a.id,
        aws_subnet.nazolog_public_subnet_1c.id,
    ]

    access_logs {
        bucket = aws_s3_bucket.nazolog_alb_log.id
        enabled = true
    }

    security_groups = [
        module.http_redirect_sg.security_group_id,
        module.https_sg.security_group_id,
    ]
}

# ALBターゲットグループ
resource "aws_lb_target_group" "nazolog_alb_target_group" {
    name = "nazolog-alb-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.nazolog_vpc.id
    deregistration_delay = 300

    health_check {
        path = "/healthcheck"
        healthy_threshold = 5
        unhealthy_threshold = 2
        timeout = 5
        interval = 30
        matcher = 200
        port = "traffic-port"
        protocol = "HTTP"
    }

    depends_on = [ aws_lb.nazolog_alb ]

    tags = {
        Name = "nazolog-alb-target-group"
    }
}

# ALBリスナー (HTTP)
resource "aws_lb_listener" "nazolog_http_listener" {
    load_balancer_arn = aws_lb.nazolog_alb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "redirect"

        redirect {
            port = "443"
            protocol = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

# ALBリスナー (HTTPS)
resource "aws_lb_listener" "nazolog_https_listener" {
    load_balancer_arn = aws_lb.nazolog_alb.arn
    port = "443"
    protocol = "HTTPS"
    certificate_arn = aws_acm_certificate.nazolog_cert_api.arn
    ssl_policy = "ELBSecurityPolicy-2016-08"

    default_action {
        target_group_arn = aws_lb_target_group.nazolog_alb_target_group.arn
        type = "forward"
    }
}
