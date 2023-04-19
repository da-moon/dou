package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/iam"

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

		groupName := terraform.Output(t, terraformOption, "name")

		t.Run("TestCreation", func(t *testing.T) {
			groupCreationTest(t, groupName)
		})
	})
}

func groupCreationTest(t *testing.T, grp string) {
	t.Log("Confirm the IAM group is created")

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("us-west-2")},
	)

	svc := iam.New(sess)
	result, err := svc.GetGroup(&iam.GetGroupInput{GroupName: aws.String(grp)})

	if err != nil {
		t.Errorf("FAIL: The group was not created, error: %s", err)
	} else {
		t.Logf("OK: The group was created: %s", *result.Group.GroupName)
	}
}
