# How to run
# opa eval --format pretty --data terraform.rego --input tfplan.json "data.terraform.analysis.authz"
# opa eval --format pretty --data terraform.rego --input tfplan.json "data.terraform.analysis.score"

provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami = "ami-0c94855ba95c71c99"
}
resource "aws_autoscaling_group" "my_asg" {
  availability_zones        = ["us-east-1a"]
  name                      = "my_asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  launch_configuration      = "my_web_config"
}
resource "aws_launch_configuration" "my_web_config" {
    name = "my_web_config"
    image_id = "ami-0c94855ba95c71c99"
    instance_type = "t2.micro"
}
