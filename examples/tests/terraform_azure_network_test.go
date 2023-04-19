package test

import (
	"testing"

	"github.com/allanore/aztest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestNetwork(t *testing.T) {
	t.Parallel()

	directory := "../../examples/terraform_code/terraform_azure_network/"

	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := &terraform.Options{
			TerraformDir: directory,
		}
		// save options to use later
		test_structure.SaveTerraformOptions(t, directory, terraformOptions)
		// terraform init and apply
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		// Load options
		terraformOptions := test_structure.LoadTerraformOptions(t, directory)
		// ouputs
		resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
		// functions
		PrefixOnResourceNameTest(t, terraformOptions, resourceGroupName)
		ResourcesTagsTest(t, terraformOptions, resourceGroupName)
	})

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, directory)
		terraform.Destroy(t, terraformOptions)
	})

}

func PrefixOnResourceNameTest(t *testing.T, terraformOptions *terraform.Options, resourceGroupName string) {
	// TEST #1 - Check the prefix on the name
	prefix := "app-terratest"

	actualVNetName := azure.GetVnetbyName(t, resourceGroupName, prefix+"-vnet", "")
	assert.Contains(t, *actualVNetName.Name, "app-")

	actualSubnetName := azure.GetSubnetbyName(t, resourceGroupName, prefix+"-vnet", prefix+"-subnet", "")
	assert.Contains(t, *actualSubnetName.Name, "app-")
}

func ResourcesTagsTest(t *testing.T, terraformOptions *terraform.Options, resourceGroupName string) {
	// TEST #2 - Check one tag with "project"
	actualVNetName := azure.GetVnetbyName(t, resourceGroupName, "app-terratest-vnet", "")
	actualVNetTags := *actualVNetName.Tags["project"]
	assert.NotEmpty(t, actualVNetTags)

	// TEST #3 - Check how many tags exists
	assert.LessOrEqual(t, len(actualVNetName.Tags), 2)
}
