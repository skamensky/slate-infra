# Billing Alert Module
# Creates CloudWatch billing alerts and SNS notifications

# SNS Topic for billing alerts
resource "aws_sns_topic" "billing_alerts" {
  name         = "${var.project_name}-billing-alerts"
  display_name = "Billing Alerts"

  tags = merge(var.tags, {
    Name = "${var.project_name}-billing-alerts"
  })
}

# SNS Topic Subscription for email notifications
resource "aws_sns_topic_subscription" "billing_alerts_email" {
  count     = length(var.alert_emails)
  topic_arn = aws_sns_topic.billing_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_emails[count.index]
}

# CloudWatch Metric Alarm for billing threshold
resource "aws_cloudwatch_metric_alarm" "billing_alert" {
  for_each = var.billing_thresholds

  alarm_name          = "${var.project_name}-billing-alert-${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "86400" # 24 hours
  statistic           = "Maximum"
  threshold           = each.value
  alarm_description   = "This metric monitors estimated charges for ${each.key}"
  alarm_actions       = [aws_sns_topic.billing_alerts.arn]
  ok_actions          = [aws_sns_topic.billing_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    Currency = "USD"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-billing-alert-${each.key}"
  })
}

# CloudWatch Billing Alarm for total account spend
resource "aws_cloudwatch_metric_alarm" "total_billing_alert" {
  alarm_name          = "${var.project_name}-total-billing-alert"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "86400"
  statistic           = "Maximum"
  threshold           = var.total_billing_threshold
  alarm_description   = "This metric monitors total estimated charges"
  alarm_actions       = [aws_sns_topic.billing_alerts.arn]
  ok_actions          = [aws_sns_topic.billing_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    Currency = "USD"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-total-billing-alert"
  })
} 