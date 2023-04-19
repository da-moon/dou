package test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/gruntwork-io/terratest/modules/terraform"

	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

var region string

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

		region = terraform.Output(t, terraformOption, "aws_region")
		id := terraform.Output(t, terraformOption, "id")
		vpc := terraform.Output(t, terraformOption, "vpc_id")
		subnet := terraform.Output(t, terraformOption, "subnet_id")

		t.Run("TestCreation", func(t *testing.T) {
			rtbCreationTest(t, id)
		})

		t.Run("TestVPC", func(t *testing.T) {
			vpcAttachedTest(t, id, vpc)
		})

		t.Run("TestRoutes", func(t *testing.T) {
			getRoutesTest(t, id, 2)
		})

		t.Run("TestAssociationsExisting", func(t *testing.T) {
			getAssociationsExistingTest(t, id, 1)
		})

		t.Run("TestResourcesAssociated", func(t *testing.T) {
			getAssociationsTest(t, id, subnet)
		})
	})
}

func rtbCreationTest(t *testing.T, rtbId string) {
	t.Log("Confirm the creation of the Route Table")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		result := getInfoResource(t, sess, rtbId)
		actual := *result.RouteTableId

		if strings.EqualFold(actual, rtbId) {
			t.Logf("OK: The Route Table with the ID %s was created successfully", rtbId)
		} else {
			t.Errorf("FAIL: The ID of the Route Table does not match. Result: %s, expected: %s", actual, rtbId)
		}
	}
}

func vpcAttachedTest(t *testing.T, rtbId, expected string) {
	t.Log("Confirm the VPC Attached to the Route Table")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("ERROR: The Authentication failed, error: ", err)
	} else {
		result := getInfoResource(t, sess, rtbId)
		vpc := *result.VpcId

		if strings.EqualFold(vpc, expected) {
			t.Logf("OK: The VPC ('%s') attached is correct", expected)
		} else {
			t.Errorf("FAIL: The VPC is not '%s', the VPC is '%s'", expected, vpc)
		}
	}
}

func getRoutesTest(t *testing.T, rtbId string, expected int) {
	t.Log("Confirm the instance type of the instance")

	var count int

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		result := getInfoResource(t, sess, rtbId)
		routes := result.Routes

		for _, v := range routes {
			if v.DestinationCidrBlock != nil {
				t.Log("Found: ", *v.DestinationCidrBlock)
				count++
			}
		}

		if count == expected {
			t.Logf("OK: There are %d routes in the Route Table", count)
		} else {
			t.Error("FAIL: There are not routes in the Route Table")
		}
	}
}

func getAssociationsExistingTest(t *testing.T, rtbId string, expected int) {
	t.Log("Confirm the number of resources attached in the Route Table")

	var count int

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		result := getInfoResource(t, sess, rtbId)
		associations := result.Associations

		for _, v := range associations {
			if *v.RouteTableId != "" {
				count++
			}
		}

		if count == expected {
			t.Logf("OK: The number of resources associated is the match, number: '%d'", expected)
		} else {
			t.Errorf("FAIL: The number of resource associated is not match, expected: '%d', actual: '%d'", expected, count)
		}
	}
}

func getAssociationsTest(t *testing.T, rtbId, expected string) {
	t.Log("Confirm the resource attached in the Route Table")

	sess, err := getAuthorizer(t, region)
	if err != nil {
		t.Error("The Authentication failed, error: ", err)
	} else {
		result := getInfoResource(t, sess, rtbId)
		associations := result.Associations

		for _, v := range associations {
			if strings.EqualFold(*v.SubnetId, expected) {
				t.Log(*v.SubnetId)
				t.Logf("OK: The resource associated is correct, resource ID: '%s'", expected)
			}
		}
	}
}

func getInfoResource(t *testing.T, session *session.Session, rtbId string) *ec2.RouteTable {
	svc := ec2.New(session)

	output, err := svc.DescribeRouteTables(&ec2.DescribeRouteTablesInput{
		RouteTableIds: []*string{aws.String(rtbId)},
	})

	if err != nil {
		t.Errorf("ERROR: %s", err)
	} else {
		for _, v := range output.RouteTables {
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
