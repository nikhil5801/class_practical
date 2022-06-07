resource "aws_autoscaling_group" "tf_asg" {
  name                = var.asg_name
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = data.aws_subnets.selected.ids

  launch_template {
    id      = aws_launch_template.tf_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.tf_asg.id
  lb_target_group_arn    = aws_lb_target_group.tf_target_group.arn
}