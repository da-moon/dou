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

func TestNetworkSPW(t *testing.T) {
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
		subnets := terraform.OutputList(t, terraformOption, "subnet_id")
		securityGroupId := terraform.OutputList(t, terraformOption, "sg_id")
		ownerId := terraform.Output(t, terraformOption, "owner_id")

		t.Run("TestVPCCreation", func(t *testing.T) {
			vpcCreatedTest(t, vpcId, region)
		})

		t.Run("TestSubnetCreation", func(t *testing.T) {
			subnetCreationTest(t, region, vpcId, subnets)
		})

		t.Run("TestSecurityGroupCreation", func(t *testing.T) {
			sgCreationTest(t, region, securityGroupId)
		})

		t.Run("TestVPCAttach", func(t *testing.T) {
			vpcAttachTest(t, region, vpcId, securityGroupId)
		})

		t.Run("TestOwnerID", func(t *testing.T) {
			getOwnerIdTest(t, region, vpcId, ownerId)
		})
	})
}

func vpcCreatedTest(t *testing.T, vpcId, region string) {
	t.Log("Confirm the VPC is created")
	vpc := terratest.GetVpcById(t, vpcId, region)

	if vpc.Id != "" {
		t.Logf("OK: The VPC was created correctly: %s", vpc.Id)
	} else {
		t.Error("FAIL: The VPC was not created")
	}
}

func subnetCreationTest(t *testing.T, region, vpcId string, expected []string) {
	t.Log("Confirm the subnet is created")

	snet := terratest.GetSubnetsForVpc(t, vpcId, region)

	for _, v := range snet {
		for _, x := range expected {
			if strings.EqualFold(x, v.Id) {
				t.Logf("OK: The subnet was created correctly: %s", v.Id)
			}
		}
	}
}

func sgCreationTest(t *testing.T, region string, securityGroupId []string) {
	t.Log("Confirm the Security Group creation")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		for _, v := range securityGroupId {
			sg := getSGInfo(t, sess, v)

			result := *sg.GroupId
			if strings.EqualFold(v, result) {
				t.Logf("OK: The Security Group (%s) is created", v)
			} else {
				t.Errorf("FAIL: The Security Group (%s) is not created", result)
			}
		}
	}
}

func vpcAttachTest(t *testing.T, region, vpcId string, securityGroupId []string) {
	t.Log("Confirm the VPC attach")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		for _, v := range securityGroupId {
			sg := getSGInfo(t, sess, v)

			result := *sg.VpcId
			if strings.EqualFold(result, vpcId) {
				t.Logf("OK: The VPC (%s) is attached to the Security Group (%s)", vpcId, v)
			} else {
				t.Errorf("FAIL: The VPC attached not match, expected: %s, result: %s", vpcId, result)
			}
		}
	}
}

func getOwnerIdTest(t *testing.T, region, vpcId, expected string) {
	t.Log("Confirm the Owner id of the resources")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {

		vpc := getVPCInfo(t, sess, vpcId)

		if strings.EqualFold(vpcId, *vpc.VpcId) {
			if strings.EqualFold(expected, *vpc.OwnerId) {
				t.Logf("OK: The owner is correct: %s", expected)
			} else {
				t.Errorf("FAIL: The actual owner is %s, expected: %s", *vpc.OwnerId, expected)
			}
		}
	}
}

func getSGInfo(t *testing.T, session *session.Session, securityGroupId string) *ec2.SecurityGroup {
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
			if strings.EqualFold(securityGroupId, *v.GroupId) {
				return v
			}
		}
	}
	return nil
}

func getVPCInfo(t *testing.T, session *session.Session, vpcId string) *ec2.Vpc {
	svc := ec2.New(session)

	output, err := svc.DescribeVpcs(&ec2.DescribeVpcsInput{
		VpcIds: []*string{
			aws.String(vpcId),
		},
	})

	if err != nil {
		t.Errorf("ERROR: %s", err)
	} else {
		for _, vpc := range output.Vpcs {
			if strings.EqualFold(vpcId, *vpc.VpcId) {
				return vpc
			}
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
