variable "aws_secret_key" {
  type        = string
}

variable "aws_access_key" {
  type        = string
}

variable "region" {
  type        = string
  description = "AWS region for deployment"
}

variable "key_name" {
  type        = string
  description = "Key pair name for SSH access"
}

variable "ami_id" {
  type        = string
}

# Define how many instances to create (Change this variable to scale)
variable "instance_count" {
  type        = number
  default     = 1
}
