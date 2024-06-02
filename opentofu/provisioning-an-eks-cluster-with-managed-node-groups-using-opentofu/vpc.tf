# Create the VPC
resource "aws_vpc" "vpc_eks" {
  cidr_block = "10.0.0.0/16"
}

# Create the first public subnet
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.vpc_eks.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
}

# Create the second public subnet
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.vpc_eks.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true
}

# Create the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_eks.id
}

# Create the Route Table for the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the Route Table with the first public subnet
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

# Associate the Route Table with the second public subnet
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}