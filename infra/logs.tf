# Set up CloudWatch group and log stream and retain logs for 30 days
/*resource "aws_cloudwatch_log_group" "hado_log_group" {
  name              = "/ecs/hado-app"
  retention_in_days = 30

  tags = {
    Name = "hado-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "hado_log_stream" {
  name           = "hado-log-stream"
  log_group_name = aws_cloudwatch_log_group.hado_log_group.name
}*/