# セキュリティグループ
module "psql_sg" {
    source = "./security_group"
    name = "psql_sg"
    vpc_id = aws_vpc.nazolog_vpc.id
    port = 5432
    cidr_blocks = [ aws_vpc.nazolog_vpc.cidr_block ]
}

# DBパラメータグループ
resource "aws_db_parameter_group" "nazolog_db_parameter" {
    name = "nazolog-db-parameter"
    family = "postgres12"
}

# DBサブネットグループ
resource "aws_db_subnet_group" "nazolog_db_subnet" {
    name = "nazolog-db-subner"
    subnet_ids = [
        aws_subnet.nazolog_private_subnet_1a.id,
        aws_subnet.nazolog_private_subnet_1c.id,
    ]
}

# DBインスタンス
resource "aws_db_instance" "nazolog_db" {
    identifier = "nazolog-db"
    engine = "postgres"
    engine_version = "12.3"
    instance_class = "db.t2.micro"
    allocated_storage = 20
    max_allocated_storage = 100
    storage_type = "gp2"
    # storage_encrypted = true # t2.microだと無理らしい
    # kms_key_id = aws_kms_key.nazolog_kms.arn
    username = "nazolog_admin"
    password = "VeryStrongPassword" # placeholder
    multi_az = false
    publicly_accessible = false
    backup_window = "09:10-09:40"
    backup_retention_period = 30
    maintenance_window = "mon:10:10-mon:10:40"
    auto_minor_version_upgrade = false
    deletion_protection = true
    skip_final_snapshot = false
    port = 5432
    apply_immediately = false
    vpc_security_group_ids = [ module.psql_sg.security_group_id ]
    parameter_group_name = aws_db_parameter_group.nazolog_db_parameter.name
    db_subnet_group_name = aws_db_subnet_group.nazolog_db_subnet.name

    lifecycle {
        ignore_changes = [ username, password ]
    }
}

