package azurerm

import (
	"testing"

	"github.com/hashicorp/terraform/helper/acctest"
	"github.com/hashicorp/terraform/helper/resource"
)

func TestAccAzureRMStorageAccount_importBasic(t *testing.T) {
	resourceName := "azurerm_storage_account.testsa"

	ri := acctest.RandInt()
	rs := acctest.RandString(4)
	config := testAccAzureRMStorageAccount_basic(ri, rs, testLocation())

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMStorageAccountDestroy,
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

func TestAccAzureRMStorageAccount_importPremium(t *testing.T) {
	resourceName := "azurerm_storage_account.testsa"

	ri := acctest.RandInt()
	rs := acctest.RandString(4)
	config := testAccAzureRMStorageAccount_premium(ri, rs, testLocation())

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMStorageAccountDestroy,
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

func TestAccAzureRMStorageAccount_importNonStandardCasing(t *testing.T) {
	resourceName := "azurerm_storage_account.testsa"

	ri := acctest.RandInt()
	rs := acctest.RandString(4)
	config := testAccAzureRMStorageAccount_nonStandardCasing(ri, rs, testLocation())

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMStorageAccountDestroy,
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

func TestAccAzureRMStorageAccount_importBlobEncryption(t *testing.T) {
	resourceName := "azurerm_storage_account.testsa"

	ri := acctest.RandInt()
	rs := acctest.RandString(4)
	config := testAccAzureRMStorageAccount_blobEncryption(ri, rs, testLocation())

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMStorageAccountDestroy,
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

// File encryption not supported by the profile 2017-03-09
func TestAccAzureRMStorageAccount_importFileEncryption(t *testing.T) {

	t.Skip()

	resourceName := "azurerm_storage_account.testsa"

	ri := acctest.RandInt()
	rs := acctest.RandString(4)
	config := testAccAzureRMStorageAccount_fileEncryption(ri, rs, testLocation())

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMStorageAccountDestroy,
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

// EnableHttpsTraffic is not supported on 2017-03-09
func TestAccAzureRMStorageAccount_importEnableHttpsTrafficOnly(t *testing.T) {

	t.Skip()

	resourceName := "azurerm_storage_account.testsa"

	ri := acctest.RandInt()
	rs := acctest.RandString(4)
	config := testAccAzureRMStorageAccount_enableHttpsTrafficOnly(ri, rs, testLocation())

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMStorageAccountDestroy,
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
