---
layout: "azurerm"
page_title: "Azure Resource Manager: azurerm_availability_set"
sidebar_current: "docs-azurerm-resource-compute-availability-set"
description: |-
  Manages an availability set for virtual machines.

---

# azurerm_availability_set

Manages an availability set for virtual machines.

## Example Usage

```hcl
resource "azurerm_resource_group" "test" {
  name     = "resourceGroup1"
  location = "West US"
}

resource "azurerm_availability_set" "test" {
  name                = "acceptanceTestAvailabilitySet1"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  tags {
    environment = "Production"
  }
}
```

## Argument Reference

The following arguments are supported:

* `name` - (Required) Specifies the name of the availability set. Changing this forces a new resource to be created.

* `resource_group_name` - (Required) The name of the resource group in which to create the availability set. Changing this forces a new resource to be created.

* `location` - (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

* `platform_update_domain_count` - (Optional) Specifies the number of update domains that are used. Defaults to 5.

~> **NOTE:** The number of Update Domains varies depending on which Azure Region you're using - [a list can be found here](https://github.com/MicrosoftDocs/azure-docs/blob/master/includes/managed-disks-common-fault-domain-region-list.md).

* `platform_fault_domain_count` - (Optional) Specifies the number of fault domains that are used. Defaults to 3.

~> **NOTE:** The number of Fault Domains varies depending on which Azure Region you're using - [a list can be found here](https://github.com/MicrosoftDocs/azure-docs/blob/master/includes/managed-disks-common-fault-domain-region-list.md).

* `tags` - (Optional) A mapping of tags to assign to the resource.

## Attributes Reference

The following attributes are exported:

* `id` - The virtual Availability Set ID.


## Import

Availability Sets can be imported using the `resource id`, e.g.

```shell
terraform import azurerm_availability_set.group1 /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Compute/availabilitySets/webAvailSet
```
