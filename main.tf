resource "aws_elasticache_subnet_group" "tfe" {
  name       = "${var.name_prefix}tfe-redis"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "redis_ingress" {
  name        = "external-redis-ingress"
  description = "Allow traffic to redis from instances in the associated SGs"
  vpc_id      = var.vpc_id

  ingress {
    description     = "TFE ingress to redis"
    from_port       = var.redis_port
    to_port         = var.redis_port
    protocol        = "tcp"
    security_groups = var.ingress_security_group_ids
  }
}

resource "aws_elasticache_replication_group" "tfe" {
  node_type                     = var.redis_node_type
  replication_group_id          = "${var.name_prefix}tfe-redis"
  replication_group_description = "External Redis for TFE."

  apply_immediately          = true
  at_rest_encryption_enabled = true
  auth_token                 = var.redis_auth_token
  automatic_failover_enabled = true
  availability_zones         = var.availability_zones
  engine                     = "redis"
  engine_version             = var.redis_engine_version
  number_cache_clusters      = length(var.availability_zones)
  parameter_group_name       = var.redis_parameter_group_name
  port                       = var.redis_port
  security_group_ids         = [aws_security_group.redis_ingress.id]
  subnet_group_name          = aws_elasticache_subnet_group.tfe.name
  transit_encryption_enabled = true
}