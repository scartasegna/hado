resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "Hado VPC"
 }
} 
resource "aws_subnet" "public_subnet" {
 vpc_id     = aws_vpc.main.id
 cidr_block = "10.0.0.0/24"
 map_public_ip_on_launch = true
 
 tags = {
   Name = "Public Subnet ecs"
 }
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "Project VPC IG"
 }
}

resource "aws_route_table" "second_rt" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "2nd Route Table"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 subnet_id      = aws_subnet.public_subnet.id
 route_table_id = aws_route_table.second_rt.id
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "hado-cluster"
}
