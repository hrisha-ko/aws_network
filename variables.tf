## Region name ##
variable "aws_region" {
  default = ""
}

## Commong information ##
variable "common_tags" {
  description = "Common tags"
  type        = map(any)
  default = {
    Owner   = ""
    Company = ""
  }
}

## Environment type ##
variable "environment" {
  description = "Type of working environment"
  type        = string
  default     = ""
}

## VPC settings ##
variable "vpc_attributes" {
  description = "VPC attributes"
  type        = map(any)
  default = {
    cidr_block = ""
  }
}

## Available Zones ##
variable "azs" {
  description = "The list of available zones"
  type        = list(string)
  default     = []
}

## Subnets settings ##
variable "public_subnets_cidrs" {
  description = "Subnets CIDR blocks"
  type        = list(string)
  default     = []
}

variable "private_subnets_cidrs" {
  description = "Subnets CIDR blocks"
  type        = list(string)
  default     = []
}

variable "public_subnet_map_public_ip" {
  description = "Map public IP on launch for public servers"
  type = string
  default = true
}

variable "private_subnet_map_public_ip" {
  description = "Map public IP on launch for private servers"
  type = string
  default = false
}

variable "db_subnets_cidrs" {
  description = "Subnets CIDR blocks"
  type        = list(string)
  default     = []
}

