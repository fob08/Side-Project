output "public_ip" {
  value = aws_instance.project1.public_ip
  description = "This is the public IP address utilized by my server"
}