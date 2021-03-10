output "redis_primary_endpoint" {
  description = "The primary endpoint of the Redis replication group."
  value       = aws_elasticache_replication_group.tfe.primary_endpoint_address
}

output "redis_port" {
  description = "The redis port."
  value       = aws_elasticache_replication_group.tfe.port
}