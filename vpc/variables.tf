variable "name" {
  description = "Nome stack"
}
variable "environment" {
  description = "Nome do ambiente"
}
variable "cidr" {
  description = "bloco de IP da VPC"
}
variable "public_subnet" {
  description = "Subnet Publica"
}
variable "private_subnet" {
  description = "Subnet Privada"
}
variable "availabilty_zone" {
  description = "Zona de disponibilidade"
}