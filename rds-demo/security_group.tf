resource "aws_security_group" "allow_rds_port" {
  name        = var.security_group_name
  description = "Allow 3306 inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "rds_port from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http_only"
  }
}