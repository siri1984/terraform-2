 #my vpc
resource "aws_vpc" "My_VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "My_VPC"
  }
}
# Public Subnet

resource "aws_subnet" "My_Public_Subnet" {
  vpc_id     = aws_vpc.My_VPC.id
  cidr_block = "10.0.15.0/24"

  tags = {
    Name = "My_Public_Subnet"
  }
}
# Private Subnet

resource "aws_subnet" "My_Private_Subnet" {
  vpc_id     = aws_vpc.My_VPC.id
  cidr_block = "10.0.12.0/24"

  tags = {
    Name = "My_Private_Subnet"
  }
}

# Route Table

resource "aws_route_table" "My_Public_Route_Table" {
  vpc_id = aws_vpc.My_VPC.id

  #route {
   # cidr_block = "10.0.1.0/24"
    #gateway_id = aws_internet_gateway.example.id
  #}

  #route {
   # ipv6_cidr_block        = "::/0"
    #egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  #}

  tags = {
    Name = "My_Public_Route_Table"
  }
}

#Private Route_table
resource "aws_route_table" "My_Private_Route_Table" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My_Private_Route_Table"
  }
}
# association of Public Subnet with Public Route Table

resource "aws_route_table_association" "My_Pub_assoc_with_RT" {
  subnet_id      = aws_subnet.My_Public_Subnet.id
  route_table_id = aws_route_table.My_Public_Route_Table.id
}
# association of Public Subnet with Private Route Table

resource "aws_route_table_association" "My_Priv_assoc_with_RT" {
  subnet_id      = aws_subnet.My_Private_Subnet.id
  route_table_id = aws_route_table.My_Private_Route_Table.id
}
# Internet Gateway

resource "aws_internet_gateway" "My_Internet_Gateway" {
  vpc_id = aws_vpc.My_VPC.id 

  tags = {
    Name = "My_Internet_Gateway"
  }
}
#Internet GAteway Association with Public Route tabble

resource "aws_route" "IGW_assoc_with_pub_RT" {
  route_table_id            = aws_route_table.My_Public_Route_Table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.My_Internet_Gateway.id
  
}