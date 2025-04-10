# this  makes  vpc.id which is aws_vpc.app1.id
resource "aws_vpc" "PipeLine_Plumbers" {
  cidr_block = "10.100.0.0/16"

  tags = {
    Name = "get_bash_PLP"
    Service = "application1"
    Owner = "PLP"
    Planet = "Kem"
  }
}

resource "aws_vpc" "dev" {
  cidr_block = "10.101.0.0/16"
  tags = {
    Name = "get_bash_dev"
    Service = "application2"
    Owner = "PLP2"
    Planet = "Kem2"
  } 
}

resource "aws_vpc" "prod" {
  cidr_block = "10.102.0.0/16"
tags = {
    Name = "get_bash_prod"
    Service = "application3"
    Owner = "PLP3"
    Planet = "Kem3"
   }
}