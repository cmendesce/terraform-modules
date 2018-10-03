module "infra" {
  source = "../infra"
}

resource "aws_security_group" "elb" {
  name        = "terraform_example_elb"
  description = "Used in the terraform"
  vpc_id      = "${module.infra.default_vpc_id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  name = "terraform-example-alb"
  internal           = false
  load_balancer_type = "application"
  subnets         = ["${module.infra.default_subnet_id}"]
  security_groups = ["${module.infra.default_security_group_id}"]
}

resource "aws_lb_target_group" "target_group" {
  name = "terraform-example-tg"
  
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${module.infra.default_vpc_id}"

}

resource "aws_lb_target_group_attachment" "tg_ec2_attachment" {
  target_group_arn = "${aws_lb_target_group.target_group.arn}"
  target_id        = "${aws_instance.web.id}"
  port             = 80
}

resource "aws_instance" "web" {
  connection {
    user = "ubuntu"
    agent = false
    private_key = "${file("${var.private_key_path}")}"
  }
  instance_type = "${var.instance_type}"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.private_key_name}"
  vpc_security_group_ids = ["${module.infra.default_security_group_id}"]
  subnet_id = "${module.infra.default_subnet_id}"
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start"
    ]
  }
}