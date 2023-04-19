package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

// Testing for a succesfull ssh connection to a VM using Azure infra
func TestTerraformSsh(t *testing.T) {
	t.Parallel()

	expectedResourceGroupName := "assurant-terratest" // must be an existing RG in the subscription
	subscriptionID := ""                              // subscriptionID is overridden by the environment variable "ARM_SUBSCRIPTION_ID

	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/terraform_code/terraform_azure_ssh/")

	// At the end of the test, run `terraform destroy` to clean up any resources that were created

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)
		terraform.Destroy(t, terraformOptions)
	})

	// Deploy the example
	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := configureTerraformOptions(t, expectedResourceGroupName, exampleFolder)

		// Save the options and key pair so later test stages can use them
		test_structure.SaveTerraformOptions(t, exampleFolder, terraformOptions)

		// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)

		testAzureTags(t, terraformOptions, expectedResourceGroupName, subscriptionID)
	})

}

func configureTerraformOptions(t *testing.T, rgName string, exampleFolder string) *terraform.Options {

	uniqueID := random.UniqueId()

	// Using the uniqueID we create a unique name for the  reources
	prefix := fmt.Sprintf("test-azure-tags-%s", uniqueID)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: exampleFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"prefix":  prefix,
			"rg_name": rgName,
		},
	}

	return terraformOptions
}

func testAzureTags(t *testing.T, terraformOptions *terraform.Options, rgName, subscriptionID string) {

	vmName := terraform.Output(t, terraformOptions, "vm_name")

	// Tags we are expected to find
	expectedTags := map[string]string{
		"hotel":   "trivago",
		"project": "assurant",
		"team":    "terratest",
	}

	// Config for .DoWithRetry
	maxRetries := 3
	timeBetweenRetries := 7 * time.Second
	description := fmt.Sprintf("Getting tags from VM %s", vmName)

	// Use DoWithRetry to repeat the test multiple times to give the instance time to boot fully
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {

		actualTags, err := azure.GetTagsForVirtualMachineE(t, vmName, rgName, subscriptionID)

		if err != nil {
			return "", err
		}

		// Loop through all the expected tags and see if they are found in the VM
		for key, value := range expectedTags {
			if value != actualTags[key] {
				// If one tag is not found, return error.
				return "", fmt.Errorf("Expected tag '%s:%s' not found", key, value)
			}
		}
		// All tags were found, return nil error
		return "", nil
	})
}
