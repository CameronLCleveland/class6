resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.PipeLine_Plumbers.id

  tags = {
    Name    = "app1_IG"
    Service = "application1"
    Owner   = "Luke"
    Planet  = "Musafar"
  }
}
