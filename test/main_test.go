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

		username := terraform.Output(t, terraformOption, "name")

		t.Run("TestCreation", func(t *testing.T) {
			userCreationTest(t, username)
		})
	})
}

func userCreationTest(t *testing.T, username string) {
	t.Log("Confirm the IAM user is created")

	sess, err := getAuthorizer(t)
	if err != nil {
		t.Error("ERROR: ", err)
	} else {
		svc := iam.New(sess)
		result, err := svc.GetUser(&iam.GetUserInput{UserName: aws.String(username)})

		if err != nil {
			t.Errorf("FAIL: The username was not created, error: %s", err)
		} else {
			t.Logf("OK: The username was created correctly: %s", *result.User.Arn)
		}
	}
}

func getAuthorizer(t *testing.T) (*session.Session, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("us-west-2")},
	)
	return sess, err
}
