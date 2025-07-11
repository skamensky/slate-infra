# Billing Alert Module

This module creates AWS CloudWatch billing alerts and SNS notifications to monitor AWS costs.

## Features

- SNS topic for billing notifications
- Email subscriptions for alerts
- Configurable billing thresholds
- Total account billing monitoring
- Proper tagging for cost allocation

## Usage

```hcl
module "billing_alert" {
  source = "../../modules/billing-alert"

  project_name            = "slate-infra"
  alert_emails           = ["admin@company.com", "finance@company.com"]
  total_billing_threshold = 100
  
  billing_thresholds = {
    warning  = 50
    critical = 80
  }

  tags = {
    Environment = "production"
    Department  = "engineering"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.10.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| aws_sns_topic.billing_alerts | resource |
| aws_sns_topic_subscription.billing_alerts_email | resource |
| aws_cloudwatch_metric_alarm.billing_alert | resource |
| aws_cloudwatch_metric_alarm.total_billing_alert | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | Name of the project | `string` | n/a | yes |
| alert_emails | List of email addresses to receive billing alerts | `list(string)` | n/a | yes |
| total_billing_threshold | Total billing threshold in USD | `number` | `100` | no |
| billing_thresholds | Map of billing thresholds by category | `map(number)` | `{ warning = 50, critical = 80 }` | no |
| tags | Additional tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| sns_topic_arn | ARN of the SNS topic for billing alerts |
| sns_topic_name | Name of the SNS topic for billing alerts |
| billing_alarm_arns | ARNs of the billing CloudWatch alarms |
| billing_alarm_names | Names of the billing CloudWatch alarms |

## Important Notes

- Billing metrics are only available in the **us-east-1** region
- Email subscriptions require manual confirmation
- Billing data is updated once per day
- The module creates both threshold-based and total billing alerts 