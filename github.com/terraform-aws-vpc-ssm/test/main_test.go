package test

import (
	"testing"

	terratest "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"

	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestMain(t *testing.T) {
	t.Parallel()

	directory := "./"

	test_structure.RunTestStage(t, "SETUP", func() {
		terraformOption := &terraform.Options{
			TerraformDir: directory,
		}
		test_structure.SaveTerraformOptions(t, directory, terraformOption)
		terraform.InitAndApply(t, terraformOption)
	})

	defer test_structure.RunTestStage(t, "TEARDOWN", func() {
		terraformOption := test_structure.LoadTerraformOptions(t, directory)
		terraform.Destroy(t, terraformOption)
	})

	test_structure.RunTestStage(t, "INTERNAL_TESTS", func() {
		terraformOption := test_structure.LoadTerraformOptions(t, directory)

		id := terraform.Output(t, terraformOption, "id")

		t.Run("TestCreation", func(t *testing.T) {
			vpcCreatedTest(t, id, "eu-central-1")
		})
	})
}

func vpcCreatedTest(t *testing.T, vpcId, region string) {
	t.Log("Confirm the VPC is created")
	vpc := terratest.GetVpcById(t, vpcId, region)

	if vpc.Id != "" {
		t.Logf("OK: The VPC was created correctly: %s", vpc.Name)
	} else {
		t.Error("FAIL: The VPC was not created")
	}
}
