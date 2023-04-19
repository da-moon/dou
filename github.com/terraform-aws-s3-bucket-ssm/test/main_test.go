package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
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

		bucketId := terraform.Output(t, terraformOption, "bucket_id")
		bucketRegion := terraform.Output(t, terraformOption, "bucket_region")

		t.Run("TestVersioning", func(t *testing.T) {
			versioningStatusTest(t, bucketRegion, bucketId, "Enabled")
		})
	})
}

func versioningStatusTest(t *testing.T, region, bucketId, expected string) {
	t.Log("Confirm the versioning status")

	isEnabled := aws.GetS3BucketVersioning(t, region, bucketId)

	if strings.EqualFold(expected, isEnabled) {
		t.Logf("OK: The versioning in the bucket is %s", expected)
	} else {
		t.Errorf("FAIL: The versioning in the bucket is %s, expected: %s", isEnabled, expected)
	}
}
