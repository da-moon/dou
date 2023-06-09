package azurerm

import (
	"testing"

	"github.com/hashicorp/terraform/helper/acctest"
	"github.com/hashicorp/terraform/helper/resource"
)

func TestAccAzureRMNetworkInterface_importBasic(t *testing.T) {
	resourceName := "azurerm_network_interface.test"
	rInt := acctest.RandInt()

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMNetworkInterfaceDestroy,
		Steps: []resource.TestStep{
			{
				Config: testAccAzureRMNetworkInterface_basic(rInt, testLocation()),
			},
			{
				ResourceName:      resourceName,
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}

func TestAccAzureRMNetworkInterface_importIPForwarding(t *testing.T) {
	resourceName := "azurerm_network_interface.test"
	rInt := acctest.RandInt()

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMNetworkInterfaceDestroy,
		Steps: []resource.TestStep{
			{
				Config: testAccAzureRMNetworkInterface_ipForwarding(rInt, testLocation()),
			},
			{
				ResourceName:            resourceName,
				ImportState:             true,
				ImportStateVerify:       true,
				ImportStateVerifyIgnore: []string{"enable_accelerated_networking"},
			},
		},
	})
}

func TestAccAzureRMNetworkInterface_importWithTags(t *testing.T) {
	resourceName := "azurerm_network_interface.test"
	rInt := acctest.RandInt()

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMNetworkInterfaceDestroy,
		Steps: []resource.TestStep{
			{
				Config: testAccAzureRMNetworkInterface_withTags(rInt, testLocation()),
			},
			{
				ResourceName:            resourceName,
				ImportState:             true,
				ImportStateVerify:       true,
				ImportStateVerifyIgnore: []string{"enable_accelerated_networking"},
			},
		},
	})
}

// Load Balancer not yet supported
func TestAccAzureRMNetworkInterface_importMultipleLoadBalancers(t *testing.T) {

	t.Skip()

	resourceName := "azurerm_network_interface.test1"
	rInt := acctest.RandInt()

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMNetworkInterfaceDestroy,
		Steps: []resource.TestStep{
			{
				Config: testAccAzureRMNetworkInterface_multipleLoadBalancers(rInt, testLocation()),
			},
			{
				ResourceName:      resourceName,
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}

// App gateway not supported
func TestAccAzureRMNetworkInterface_importApplicationGateway(t *testing.T) {

	t.Skip()

	resourceName := "azurerm_network_interface.test"
	rInt := acctest.RandInt()

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMNetworkInterfaceDestroy,
		Steps: []resource.TestStep{
			{
				Config: testAccAzureRMNetworkInterface_applicationGatewayBackendPool(rInt, testLocation()),
			},
			{
				ResourceName:      resourceName,
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}

// public IP not yet supported
func TestAccAzureRMNetworkInterface_importPublicIP(t *testing.T) {

	t.Skip()

	resourceName := "azurerm_network_interface.test"
	rInt := acctest.RandInt()

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMNetworkInterfaceDestroy,
		Steps: []resource.TestStep{
			{
				Config: testAccAzureRMNetworkInterface_publicIP(rInt, testLocation()),
			},
			{
				ResourceName:      resourceName,
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}

// App Security Group not supported
func TestAccAzureRMNetworkInterface_importApplicationSecurityGroup(t *testing.T) {

	t.Skip()

	resourceName := "azurerm_network_interface.test"
	rInt := acctest.RandInt()

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testCheckAzureRMNetworkInterfaceDestroy,
		Steps: []resource.TestStep{
			{
				Config: testAccAzureRMNetworkInterface_applicationSecurityGroup(rInt, testLocation()),
			},
			{
				ResourceName:      resourceName,
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}
