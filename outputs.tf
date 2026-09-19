output "alb_dns_name" {
  description = "Open this URL in the browser"
  value       = "http://${aws_lb.this.dns_name}"
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.web.name
}

output "launch_template_id" {
  description = "Launch template used by the ASG"
  value       = aws_launch_template.web.id
}
