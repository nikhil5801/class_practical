variable "ami_id" {
  type    = string
  default = "ami-04893cdb768d0f9ee"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "asg_name" {
  type    = string
  default = "asg_demo_terraform"
}

variable "lb_name" {
  type    = string
  default = "alb-demo-terraform"
}

variable "security_group_name" {
  type    = string
  default = "sg_allow_http_tf"
}

variable "aws_instance" {
  type    = string
  default = "tf_demo"
}

variable "launch_template_name" {
  type    = string
  default = "tf_launch_template_new"
}

variable "target_group_name" {
  type    = string
  default = "tf-target-group"
}

variable "listner_name" {
  type    = string
  default = "tf_listners"
}

variable "key_name" {
  type    = string
  default = "asg-Web-Server"
}

variable "max_size" {
  type    = string
  default = "3"
}

variable "desired_capacity" {
  type    = string
  default = "2"
}

variable "min_size" {
  type    = string
  default = "1"
}
