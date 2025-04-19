resource "aws_lb" "frontend_lb" {
  name               = "frontend-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.final_sg.id]
  subnets            = [aws_subnet.sn1.id, aws_subnet.sn2.id]

  enable_deletion_protection = false

  tags = {
    Name = "frontend-load-balancer"
  }
}

# Creating the target group first
resource "aws_lb_target_group" "frontend_tg" {
  name        = "frontend-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/index.html"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    matcher             = "200,302,304"
  }
}

# Listener configuration
resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.frontend_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}
