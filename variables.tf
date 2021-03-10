variable "name_prefix" {
  type        = string
  description = "A string to be used as prefix for generating names of the created resources."
  default     = "tfe-"
}

variable "common_tags" {
  type        = map(string)
  description = "The common tags to use with the managed resources. The default value is used as an example."
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC in which the Elasticache subnet group will be."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to use for the Elasticache subnet group will be."
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones in which to place the Elasticache nodes."
}

variable "ingress_security_group_ids" {
  type        = list(string)
  description = "List of security group ids from which ingress traffic to the Elasticache service is allowed."
}

variable "redis_port" {
  type        = number
  description = "Port Redis will listen on."
  default     = 6379
}

variable "redis_node_type" {
  type        = string
  description = "The size of the Redis nodes."
  default     = "cache.m4.large"
}

variable "redis_auth_token" {
  type        = string
  description = "Auth token for the Redis."
  sensitive   = true
}

variable "redis_engine_version" {
  type        = string
  description = "Redis engine version."
  default     = "5.0.6"
}

variable "redis_parameter_group_name" {
  type        = string
  description = "The name of the parameter group to associate with this replication group."
  default     = null
}
