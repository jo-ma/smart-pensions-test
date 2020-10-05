variable "api_service_name" {
  type        = string
  description = "The name of the API service we are deploying"
  default     = "api-service"
}

variable "app_name" {
  type        = string
  description = "The unique identifier for the application being deployed"
  default     = "smart-pension-reasons"
}

variable "app_image" {
  type        = string
  description = "The docker image for the api service"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile for Terraform AWS access"
}

variable "aws_region" {
  type        = string
  description = "AWS region for application"
}

variable "db" {
  type        = string
  description = "The database name"
}

variable "db_password" {
  type        = string
  description = "The password for the application database user"
}

variable "db_username" {
  type        = string
  description = "The username for the application user"
}

variable "env" {
  type        = string
  description = "The environment stage the application is being deployed to"
}