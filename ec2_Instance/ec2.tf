resource "aws_instance" "webserver" {
  ami                    = "ami-04893cdb768d0f9ee"
  instance_type          = "t2.micro"
  count                  = "1"
  subnet_id              = "subnet-0ee247e36afc05708"
  key_name               = "asg-Web-Server"
  vpc_security_group_ids = [aws_security_group.allow_http.id]


  tags = {
    Name      = "Webapp_Server"
    addedBytf = "automation"
  }
}
