locals {
  # Use the ALB DNS name as the backend API URL
  backend_api_url = aws_lb.app_lb.dns_name != "" ? "http://${aws_lb.app_lb.dns_name}" : var.api_url
}
