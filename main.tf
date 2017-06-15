module "web" {
  source = "./modules/web"
  private_key_name = "${var.private_key_name}"
  private_key_path = "${var.private_key_path}"
  aws_region = "${var.aws_region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}
