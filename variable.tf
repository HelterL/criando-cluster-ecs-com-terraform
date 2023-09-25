variable "name" {
  description = "Nome stack"
  default = "Terraform ECS"
}
variable "environment" {
  description = "Nome do ambiente"
  default = "Terrform ECS"
}
variable "cidr" {
  description = "bloco de IP da VPC"
  default = "10.0.0.0/16"
}
variable "public_subnet" {
  description = "Subnet Publica"
  default = "10.0.1.0/24"
}
variable "private_subnet" {
  description = "Subnet Privada"
  default = "10.0.2.0/24"
}
variable "availabilty_zone" {
  description = "Zona de disponibilidade"
  default = "us-east-1a"
}