# resource "aws_lb" "app_lb" {
#   name               = "app-load-balancer"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.final_sg.id]
#   subnets            = [aws_subnet.sn1.id, aws_subnet.sn2.id]

#   enable_deletion_protection = false

#   tags = {
#     Name = "app-load-balancer"
#   }
# }

# resource "aws_lb_target_group" "app_tg" {
#   name        = "app-target-group"
#   port        = 3004
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.main.id
#   target_type = "ip"

#   health_check {
#     enabled             = true
#     interval            = 30
#     path                = "/healthz"
#     port                = "traffic-port"
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#     timeout             = 5
#     matcher             = "200"
#   }
# }

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app_tg.arn
#   }
# }

# # Output the ALB DNS name for use in frontend configuration
# output "backend_service_endpoint" {
#   value       = "http://${aws_lb.app_lb.dns_name}"
#   description = "The endpoint of the backend service"
# }

