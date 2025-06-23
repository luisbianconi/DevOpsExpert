output "public_ip" {
  description = "Public IP of the EC2 instance running K3s"
  value       = aws_instance.k3s.public_ip
}
