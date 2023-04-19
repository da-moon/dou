package test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
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
		securityGroupId := terraform.Output(t, terraformOption, "id")
		ownerId := terraform.Output(t, terraformOption, "owner_id")

		t.Run("TestSecurityGroupCreation", func(t *testing.T) {
			sgCreationTest(t, region, securityGroupId)
		})

		t.Run("TestVPCAttach", func(t *testing.T) {
			vpcAttachTest(t, region, securityGroupId, vpcId)
		})

		t.Run("TestIngressProtocol", func(t *testing.T) {
			ingressProtocolTest(t, region, securityGroupId, "TCP")
		})

		t.Run("TestEgressProtocol", func(t *testing.T) {
			egressProtocolTest(t, region, securityGroupId, "-1") // All ports
		})

		t.Run("TestOwnerID", func(t *testing.T) {
			getOwnerIdTest(t, region, securityGroupId, ownerId)
		})
	})
}

func sgCreationTest(t *testing.T, region, securityGroupId string) {
	t.Log("Confirm the Security Group creation")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		sg := getInfoResource(t, sess, securityGroupId)

		result := *sg.GroupId
		if strings.EqualFold(securityGroupId, result) {
			t.Logf("OK: The Security Group (%s) is created", securityGroupId)
		} else {
			t.Errorf("FAIL: The Security Group (%s) is not created", result)
		}
	}
}

func vpcAttachTest(t *testing.T, region, securityGroupId, expected string) {
	t.Log("Confirm the VPC attach")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		sg := getInfoResource(t, sess, securityGroupId)

		result := *sg.VpcId
		if strings.EqualFold(result, expected) {
			t.Logf("OK: The VPC (%s) is attached to the Security Group", expected)
		} else {
			t.Errorf("FAIL: The VPC attached not match, expected: %s, result: %s", expected, result)
		}
	}
}

func ingressProtocolTest(t *testing.T, region, securityGroupId, expected string) {
	t.Log("Confirm the ingress IP procotol")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		sg := getInfoResource(t, sess, securityGroupId)

		for _, v := range sg.IpPermissions {
			result := *v.IpProtocol
			if strings.EqualFold(expected, result) {
				t.Logf("OK: The Procotol match with the expected: %s", expected)
			} else {
				t.Errorf("FAIL: The Protocol does not match with the expected: %s, result: %s", expected, result)
			}
		}
	}
}

func egressProtocolTest(t *testing.T, region, securityGroupId, expected string) {
	t.Log("Confirm the egress IP procotol")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		sg := getInfoResource(t, sess, securityGroupId)

		for _, v := range sg.IpPermissionsEgress {
			result := *v.IpProtocol

			if strings.EqualFold(expected, result) {
				t.Logf("OK: The Procotol match with the expected: %s", expected)
			} else {
				t.Errorf("FAIL: The Protocol does not match with the expected: %s, result: %s", expected, result)
			}
		}
	}
}

func getOwnerIdTest(t *testing.T, region, securityGroupId, expected string) {
	t.Log("Confirm the Owner id of the Security Group")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		sg := getInfoResource(t, sess, securityGroupId)
		result := *sg.OwnerId

		if strings.EqualFold(expected, result) {
			t.Logf("OK: The owner is correct: %s", expected)
		} else {
			t.Errorf("FAIL: The actual owner is %s, expected: %s", result, expected)
		}
	}
}

func getInfoResource(t *testing.T, session *session.Session, securityGroupId string) *ec2.SecurityGroup {
	svc := ec2.New(session)

	output, err := svc.DescribeSecurityGroups(&ec2.DescribeSecurityGroupsInput{
		GroupIds: []*string{
			aws.String(securityGroupId),
		},
	})

	if err != nil {
		t.Errorf("ERROR: %s", err)
	} else {
		for _, v := range output.SecurityGroups {
			return v
		}
	}
	return nil
}

func getAuthorizer(t *testing.T, region string) (*session.Session, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)
	return sess, err
}
