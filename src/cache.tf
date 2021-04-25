# セキュリティグループ
module "redis_sg" {
    source = "./security_group"
    name = "redis-sg"
    vpc_id = aws_vpc.nazolog_vpc.id
    port = 6379
    cidr_blocks = [ aws_vpc.nazolog_vpc.cidr_block ]
}

# パラメータグループ
resource "aws_elasticache_parameter_group" "nazolog_cache_parameter_group" {
    name = "nazolog-cache-parameter-group"
    family = "redis6.x"

    parameter {
        name = "cluster-enabled"
        value = "no"
    }
}

# サブネットグループ
resource "aws_elasticache_subnet_group" "nazolog_cache_subnet_group" {
    name = "nazolog-cache-subnet-group"
    subnet_ids = [
        aws_subnet.nazolog_private_subnet_1a.id,
        # aws_subnet.nazolog_private_subnet_1c.id,
    ]
}

# レプリケーショングループ
resource "aws_elasticache_replication_group" "nazolog_cache" {
    replication_group_id = "nazolog-cache"
    replication_group_description = "Cluster Disabled"
    engine = "redis"
    # engine_version = "6.x"
    number_cache_clusters = 1
    node_type = "cache.t2.micro"
    snapshot_window = "09:10-10:10"
    snapshot_retention_limit = 7
    maintenance_window = "mon:10:40-mon:11:40"
    automatic_failover_enabled = false
    port = 6379
    apply_immediately = false
    security_group_ids = [ module.redis_sg.security_group_id ]
    parameter_group_name = aws_elasticache_parameter_group.nazolog_cache_parameter_group.name
    subnet_group_name = aws_elasticache_subnet_group.nazolog_cache_subnet_group.name
}