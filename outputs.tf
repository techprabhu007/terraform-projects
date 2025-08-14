output "lb_dns_name" {
  description = "The public DNS name of the Application Load Balancer."
  value       = aws_lb.main_alb.dns_name
}