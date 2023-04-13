# Autoscaling Notifications
## SNS - Topic
resource "aws_sns_topic" "asg_sns_topic" {
  name = "asg-sns-topic"
}

## SNS - Subscription
resource "aws_sns_topic_subscription" "asg_sns_topic_subscription" {
  topic_arn = aws_sns_topic.asg_sns_topic.arn
  protocol  = var.sns_topic_protocol
  endpoint  = var.sns_topic_endpoint
}

## Create Autoscaling Notification Resource
resource "aws_autoscaling_notification" "asg_notifications" {
  group_names = [aws_autoscaling_group.this.id]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.asg_sns_topic.arn
}
