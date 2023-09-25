resource "aws_security_group" "main" {
  name = var.name
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name: "${var.name}-sec-group-${var.environment}"
    Environment = var.environment
  }
}

output "sg_id" {
  value = aws_security_group.main.id
}