resource "aws_db_instance" "rdsdemo" {
  allocated_storage    = 10
  engine               = "mysql"
  identifier           = "terraform-rds-demo"
  engine_version       = "8.0.28"
  instance_class       = "db.t2.micro"
  db_name              = "rdsdemo"
  username             = "admin"
  password             = "admin123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.allow_rds_port.id]
}