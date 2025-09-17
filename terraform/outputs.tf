output "instance_ids" {
  description = "IDs of all EC2 instances"
  value       = { for k, v in aws_instance.vm : k => v.id }
}

output "public_ips" {
  description = "Public IPs of all EC2 instances (if assigned)"
  value       = { for k, v in aws_instance.vm : k => v.public_ip }
}

output "private_ips" {
  description = "Private IPs of all EC2 instances"
  value       = { for k, v in aws_instance.vm : k => v.private_ip }
}
