# The following locals are used to extract the Policy Set Definitions
# configuration from the archetype module output.
locals {
  es_policy_set_definitions_by_management_group = flatten([
    for archetype in values(module.management_group_archetypes) :
    archetype.configuration.policy_set_definitions
  ])
  es_policy_set_definitions_by_subscription = []
}
