terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "farmsy_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "farmsy-vpc"
  }
}

resource "aws_subnet" "farmsy_public_subnet" {
  vpc_id                  = aws_vpc.farmsy_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "farmsy-public-subnet"
  }
}

resource "aws_internet_gateway" "farmsy_igw" {
  vpc_id = aws_vpc.farmsy_vpc.id

  tags = {
    Name = "farmsy-igw"
  }
}

resource "aws_route_table" "farmsy_rt" {
  vpc_id = aws_vpc.farmsy_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.farmsy_igw.id
  }

  tags = {
    Name = "farmsy-rt"
  }
}

resource "aws_route_table_association" "farmsy_rta" {
  subnet_id      = aws_subnet.farmsy_public_subnet.id
  route_table_id = aws_route_table.farmsy_rt.id
}

# Core services to provision:
# - RDS PostgreSQL (db.t3.medium, Multi-AZ for prod)
# - ElastiCache Redis (cache.t3.micro)
# - ECS Fargate for:
#     - customer-web (Next.js)
#     - farmer-app (Next.js)
#     - admin-dashboard (Next.js)
#     - worker (BullMQ background jobs)
#     - meilisearch (search)
# - S3 bucket (product images, farmer docs, packing list PDFs)
# - CloudFront distribution (S3 + API cache)
# - ACM SSL certificates
# - Route53 DNS:
#     farmy.in → customer-web
#     farmer.farmy.in → farmer-app
#     admin.farmy.in → admin-dashboard
# - ECR repositories for each app
# - Secrets Manager for all API keys
# - CloudWatch alarms:
#     - API error rate > 1%
#     - Order processing lag > 5 min
#     - Failed payouts
