resource "aws_alb" "main" {
  count = var.number_of_load_balancers
  name = "pydata-bigdatarepublic-${count.index}"
  subnets = aws_subnet.public.*.id
  security_groups = [
    aws_security_group.lb.id]
}

resource "aws_alb_listener" "fixed_response" {
  count = var.number_of_load_balancers
  load_balancer_arn = aws_alb.main[count.index].arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HTTP Error 404: Please provide username"
      status_code = 404
    }
  }
}
