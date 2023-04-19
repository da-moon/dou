
data "aws_caller_identity" "current" {}

data "template_file" "dashboard_json" {
  template = "${file("${path.module}/dashboard.json")}"
  vars = {
    region     = var.region,
    env_name   = var.env_name
    account_id = data.aws_caller_identity.current.account_id
    alarms     = join("\",\"", [
      aws_cloudwatch_metric_alarm.web.arn,
      join("\",\"", aws_cloudwatch_metric_alarm.fsc[*].arn),
      join("\",\"", aws_cloudwatch_metric_alarm.poolmgr[*].arn),
      aws_cloudwatch_metric_alarm.licserver.arn,
      aws_cloudwatch_metric_alarm.db.arn,
      aws_cloudwatch_metric_alarm.awg.arn,
      aws_cloudwatch_metric_alarm.ms_sd.arn,
      aws_cloudwatch_metric_alarm.ms_afx.arn,
      aws_cloudwatch_metric_alarm.ms_tcgql.arn,
      aws_cloudwatch_metric_alarm.ms_filerepo.arn,
      aws_cloudwatch_metric_alarm.indexing_engine.arn,
    ])
  }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.dashboard_name
  dashboard_body = data.template_file.dashboard_json.rendered
}

resource "aws_cloudwatch_metric_alarm" "web" {
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-web-reachable": "tc-${var.env_name}-web-reachable"
  alarm_description = "Alarm that indicates if the web tier is reachable at ${var.web_hostname}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "web-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.web_hostname
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "fsc" {
  count             = length(var.fsc_servers)
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-fsc-reachable-${count.index}": "tc-${var.env_name}-fsc-reachable-${count.index}"
  alarm_description = "Alarm that indicates if the FSC server is reachable at ${var.fsc_servers[count.index]}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "fsc-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.fsc_servers[count.index]
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "poolmgr" {
  count             = length(var.poolmgr_servers)
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-poolmgr-reachable-${count.index}": "tc-${var.env_name}-poolmgr-reachable-${count.index}"
  alarm_description = "Alarm that indicates if the pool manager server is reachable at ${var.poolmgr_servers[count.index]}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "poolmgr-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.poolmgr_servers[count.index]
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "licserver" {
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-licsrv-reachable": "tc-${var.env_name}-licsrv-reachable"
  alarm_description = "Alarm that indicates if the license server is reachable at ${var.license_server}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "licserver-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.license_server
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "db" {
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-db-reachable": "tc-${var.env_name}-db-reachable"
  alarm_description = "Alarm that indicates if the database is reachable at ${var.db_server}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "db-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.db_server
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "awg" {
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-awg-reachable": "tc-${var.env_name}-awg-reachable"
  alarm_description = "Alarm that indicates if the Active Workspace Gateway is reachable at ${var.awg_server}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "awg-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.awg_server
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "ms_sd" {
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ms-sd-reachable": "tc-${var.env_name}-ms-sd-reachable"
  alarm_description = "Alarm that indicates if the microservice Service Dispatcher is reachable at ${var.ms_server}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "ms/sd-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.ms_server
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "ms_afx" {
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ms-afx-reachable": "tc-${var.env_name}-ms-afx-reachable"
  alarm_description = "Alarm that indicates if the microservice afx darsi is reachable at ${var.ms_server}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "ms/afx-darsi-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.ms_server
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "ms_tcgql" {
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ms-tcgql-reachable": "tc-${var.env_name}-ms-tcgql-reachable"
  alarm_description = "Alarm that indicates if the microservice tcgql is reachable at ${var.ms_server}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "ms/tcgql-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.ms_server
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "ms_filerepo" {
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ms-filerepo-reachable": "tc-${var.env_name}-ms-filerepo-reachable"
  alarm_description = "Alarm that indicates if the microservice filerepo is reachable at ${var.ms_server}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "ms/filerepo-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.ms_server
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "indexing_engine" {
  alarm_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ms-indexing-reachable": "tc-${var.env_name}-ms-indexing-reachable"
  alarm_description = "Alarm that indicates if the indexing engine server is reachable at ${var.indexing_server}."
  actions_enabled   = true
  alarm_actions     = [
    var.sns_arn,
  ]
  comparison_operator       = "LessThanThreshold"
  threshold                 = 1
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  ok_actions                = []
  treat_missing_data        = "missing"

  metric_query {
    id          = "q1"
    return_data = true

    metric {
      metric_name = "idx-up"
      namespace   = "Engcloud/Teamcenter"
      period      = "60"
      stat        = "Average"

      dimensions = {
        Environment = var.env_name
        Hostname    = var.indexing_server
      }
    }
  }
}


