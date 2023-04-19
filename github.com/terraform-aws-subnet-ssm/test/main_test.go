package test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	terratest "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/aws/aws-sdk-go/service/ec2"

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

		region := terraform.Output(t, terraformOption, "region")
		vpcId := terraform.Output(t, terraformOption, "vpc_id")
		subnetId := terraform.Output(t, terraformOption, "subnet_id")
		ownerId := terraform.Output(t, terraformOption, "owner_id")

		t.Run("TestCreation", func(t *testing.T) {
			subnetCreationTest(t, region, vpcId, subnetId)
		})

		t.Run("TestPublicSubnet", func(t *testing.T) {
			publicSubnetTest(t, region, subnetId)
		})

		t.Run("TestOwnerID", func(t *testing.T) {
			getOwnerIdTest(t, region, subnetId, ownerId)
		})
	})
}

func subnetCreationTest(t *testing.T, region, vpcId, expected string) {
	t.Log("Confirm the subnet is created")

	snet := terratest.GetSubnetsForVpc(t, vpcId, region)

	for _, v := range snet {
		if strings.EqualFold(expected, v.Id) {
			t.Logf("OK: The subnet was created correctly: %s", v.Id)
		}
	}
}

func publicSubnetTest(t *testing.T, region, subnetId string) {
	t.Log("Confirm the subnet is public")

	result := terratest.IsPublicSubnet(t, subnetId, region)

	if !result {
		t.Logf("OK: The subnet (%s) was not public", subnetId)
	} else {
		t.Errorf("FAIL: The subnet (%s) was public", subnetId)
	}
}

func getOwnerIdTest(t *testing.T, region, subnetId, expected string) {
	t.Log("Confirm the Owner id of the subnet")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		svc := ec2.New(sess)

		input := &ec2.DescribeSubnetsInput{
			SubnetIds: []*string{aws.String(subnetId)},
		}
		out, err := svc.DescribeSubnets(input)
		if err != nil {
			t.Error("FAIL: Subnet no found: ", err)
		} else {
			for _, v := range out.Subnets {
				if strings.EqualFold(expected, *v.OwnerId) {
					t.Logf("OK: The owner is correct: %s", expected)
				} else {
					t.Errorf("FAIL: The actual owner is %s, expected: %s", *v.OwnerId, expected)
				}
			}
		}
	}
}

func getAuthorizer(t *testing.T, region string) (*session.Session, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)
	return sess, err
}
