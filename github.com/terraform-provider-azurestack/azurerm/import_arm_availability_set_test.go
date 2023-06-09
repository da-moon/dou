package azurerm

import (
	"testing"

	"github.com/hashicorp/terraform/helper/acctest"
	"github.com/hashicorp/terraform/helper/resource"
)

func TestAccAzureRMAvailabilitySet_importBasic(t *testing.T) {
	resourceName := "azurerm_availability_set.test"

	ri := acctest.RandInt()
	config := testAccAzureRMAvailabilitySet_basic(ri, testLocation())

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMAvailabilitySetDestroy,
		Steps: []resource.TestStep{
			{
				Config: config,
			},

			{
				ResourceName:      resourceName,
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}

func TestAccAzureRMAvailabilitySet_importWithTags(t *testing.T) {
	resourceName := "azurerm_availability_set.test"

	ri := acctest.RandInt()
	config := testAccAzureRMAvailabilitySet_withTags(ri, testLocation())

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMAvailabilitySetDestroy,
		Steps: []resource.TestStep{
			{
				Config: config,
			},

			{
				ResourceName:      resourceName,
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}

func TestAccAzureRMAvailabilitySet_importWithDomainCounts(t *testing.T) {
	resourceName := "azurerm_availability_set.test"

	ri := acctest.RandInt()
	config := testAccAzureRMAvailabilitySet_withDomainCounts(ri, testLocation())

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMAvailabilitySetDestroy,
		Steps: []resource.TestStep{
			{
				Config: config,
			},

			{
				ResourceName:      resourceName,
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}

// Managed is not supported in the profile, skipping
func TestAccAzureRMAvailabilitySet_importManaged(t *testing.T) {

	t.Skip()

	resourceName := "azurerm_availability_set.test"

	ri := acctest.RandInt()
	config := testAccAzureRMAvailabilitySet_managed(ri, testLocation())

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMAvailabilitySetDestroy,
		Steps: []resource.TestStep{
			{
				Config: config,
			},

			{
				ResourceName:      resourceName,
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}
