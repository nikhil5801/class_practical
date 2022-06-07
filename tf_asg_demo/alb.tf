resource "aws_lb" "tf_lb_demo" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http_only.id]
  subnets            = data.aws_subnets.selected.ids

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "tf_target_group" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id
}

resource "aws_lb_listener" "tf_listners" {
  load_balancer_arn = aws_lb.tf_lb_demo.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_target_group.arn
  }
}
