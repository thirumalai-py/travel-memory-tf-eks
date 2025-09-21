provider "aws" {
  region = var.aws_region
  # credentials resolved from environment / profile / instance role
}
