locals {
  ### Grab Latest Version of Pattern For Tagging ###
  raw_lines = [
    for line in split("\n", file("${path.module}/CHANGELOG.md")) :
    split("\"", trimspace(line))
  ]

  lines = [
    for line in local.raw_lines :
    line if length(line[0]) > 0 && substr(line[0], 0, 1) != "#"
  ]

  records         = concat(tolist([for line in local.lines : upper(line[1])]), tolist([""]))
  pattern_version = length(local.records) < 2 ? "V1.0" : format("%s%s", "V", local.records[0])

  ### Append VPC info and Name tag of Target Groups to each Target Group ###
  target_group_additions = flatten([
    for k, v in var.target_groups : [
      { vpc_id = lookup(v, "vpc_id", null), vpc_id = module.datasource-module.data.vpc_id
      name = lookup(v, "name", null), name = "${module.label-module-tg.name}${index(var.target_groups, v) + 1}" }
    ]
  ])

  target_groups_revised = [for index, x in var.target_groups : merge(x, local.target_group_additions[index])]

  ### Create revised list of block device mappings ensuring it's always encrypted ###
  block_device_mappings = flatten([
    for k, v in var.block_device_mappings : [
      { kms_key_id = lookup(v, "kms_key_id", null), kms_key_id = module.datasource-module.data.ebs_kms.arn_alias
      encrypted = lookup(v, "encrypted", null), encrypted = "true" }
    ]
  ])

  block_device_mappings_revised = [for index, x in var.block_device_mappings : merge(x, local.block_device_mappings[index])]

}
