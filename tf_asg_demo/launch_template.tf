resource "aws_launch_template" "tf_launch_template" {
  name          = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  monitoring {
    enabled = true
  }

  /*network_interfaces {
    associate_public_ip_address = true
  }

  #placement {
  #  availability_zone = "us-west-2a"
*/
  vpc_security_group_ids = [aws_security_group.allow_http_only.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "launch_template_tf"
    }
  }

  user_data = filebase64("${path.module}/user_data.sh")
}