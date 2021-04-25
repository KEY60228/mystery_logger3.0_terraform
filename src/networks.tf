# VPCリソース
resource "aws_vpc" "nazolog_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "nazolog-vpc"
    }
}

# インターネットゲートウェイリソース
resource "aws_internet_gateway" "nazolog_igw" {
    vpc_id = aws_vpc.nazolog_vpc.id

    tags = {
        Name = "nazolog-internet-gateway"
    }
}

### public
# ルートテーブルリソース
resource "aws_route_table" "nazolog_public_route_table" {
    vpc_id = aws_vpc.nazolog_vpc.id

    tags = {
        Name = "nazolog-route-table"
    }
}

# ルートリソース (インターネットゲートウェイとルートテーブルの紐付け)
resource "aws_route" "nazolog_route" {
    route_table_id = aws_route_table.nazolog_public_route_table.id
    gateway_id = aws_internet_gateway.nazolog_igw.id
    destination_cidr_block = "0.0.0.0/0"
}

### public 1a
# public-1a Subnetリソース
resource "aws_subnet" "nazolog_public_subnet_1a" {
    vpc_id = aws_vpc.nazolog_vpc.id
    cidr_block = "10.0.10.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-northeast-1a"

    tags = {
        Name = "nazolog-public-subnet-1a"
    }
}

# サブネットとルートテーブルの紐付け
resource "aws_route_table_association" "nazolog_public_1a_route_table_association" {
    subnet_id = aws_subnet.nazolog_public_subnet_1a.id
    route_table_id = aws_route_table.nazolog_public_route_table.id
}

### public 1c
# public-1c Subnetリソース
resource "aws_subnet" "nazolog_public_subnet_1c" {
    vpc_id = aws_vpc.nazolog_vpc.id
    cidr_block = "10.0.11.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-northeast-1c"

    tags = {
        Name = "nazolog-public-subnet-1c"
    }
}

# サブネットとルートテーブルの紐付け
resource "aws_route_table_association" "nazolog_public_1c_route_table_association" {
    subnet_id = aws_subnet.nazolog_public_subnet_1c.id
    route_table_id = aws_route_table.nazolog_public_route_table.id
}

### private
# ルートテーブルリソース
resource "aws_route_table" "nazolog_private_route_table" {
    vpc_id = aws_vpc.nazolog_vpc.id
}

### private 1a
# private-1a Subnetリソース
resource "aws_subnet" "nazolog_private_subnet_1a" {
    vpc_id = aws_vpc.nazolog_vpc.id
    cidr_block = "10.0.20.0/24"
    availability_zone = "ap-northeast-1a"
    map_public_ip_on_launch = false

    tags = {
        Name = "nazolog-private-subnet-1a"
    }
}

# サブネットとルートテーブルの紐付け
resource "aws_route_table_association" "nazolog_private_1a_route_table_association" {
    subnet_id = aws_subnet.nazolog_private_subnet_1a.id
    route_table_id = aws_route_table.nazolog_private_route_table.id
}

### private 1c
# private-1c Subnetリソース
resource "aws_subnet" "nazolog_private_subnet_1c" {
    vpc_id = aws_vpc.nazolog_vpc.id
    cidr_block = "10.0.21.0/24"
    availability_zone = "ap-northeast-1c"
    map_public_ip_on_launch = false

    tags = {
        Name = "nazolog-private-subnet-1c"
    }
}

# サブネットとルートテーブルの紐付け
resource "aws_route_table_association" "nazolog_private_1c_route_table_association" {
    subnet_id = aws_subnet.nazolog_private_subnet_1c.id
    route_table_id = aws_route_table.nazolog_private_route_table.id
}
