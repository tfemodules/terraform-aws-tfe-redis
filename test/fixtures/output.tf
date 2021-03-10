output "test_instance_public_ip" {
  description = "The public IP of the EC2 instance to use for tests."
  value       = aws_instance.test.public_ip
}