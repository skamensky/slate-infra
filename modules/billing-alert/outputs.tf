output "sns_topic_arn" {
  description = "ARN of the SNS topic for billing alerts"
  value       = aws_sns_topic.billing_alerts.arn
}

output "sns_topic_name" {
  description = "Name of the SNS topic for billing alerts"
  value       = aws_sns_topic.billing_alerts.name
}

output "billing_alarm_arns" {
  description = "ARNs of the billing CloudWatch alarms"
  value = merge(
    { for k, v in aws_cloudwatch_metric_alarm.billing_alert : k => v.arn },
    { total = aws_cloudwatch_metric_alarm.total_billing_alert.arn }
  )
}

output "billing_alarm_names" {
  description = "Names of the billing CloudWatch alarms"
  value = merge(
    { for k, v in aws_cloudwatch_metric_alarm.billing_alert : k => v.alarm_name },
    { total = aws_cloudwatch_metric_alarm.total_billing_alert.alarm_name }
  )
} 