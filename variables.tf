variable "alb_listener_arn" {
  description = "ARN of ALB Listener to route traffic to"
}

variable "rule_priority" {
  description = "Priority of this rule. A priority of 1 = default rule if no matches are found. So rules are excecuted low -> high and first match gets route. If no matches prioity of 1 is the path. "
}

variable "path_patterns" {
  description = "CSV list of path patterns to match this rule on"
}

variable "target_group_arn" {
  description = "ARN of target group to send traffic to if this rule is matched for a specific request."
}

