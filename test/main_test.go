package test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/gruntwork-io/terratest/modules/terraform"

	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

var region string

func TestInstance(t *testing.T) {
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
		snsId := terraform.Output(t, terraformOption, "sns_arn")

		t.Run("TestCreation", func(t *testing.T) {
			creationTest(t, id)
		})

		t.Run("TestSNSConfiguration", func(t *testing.T) {
			getSNSConfigTest(t, id, snsId)
		})

		t.Run("TestLambdaConfiguration", func(t *testing.T) {
			getLambdaConfigTest(t, id, "")
		})

		t.Run("TestQueueConfiguration", func(t *testing.T) {
			getQueueConfigTest(t, id, "")
		})
	})
}

func creationTest(t *testing.T, bucketId string) {
	t.Log("Confirm the creation of the S3 Bucket")

	sess, err := getAuthorizer(t)
	var creation bool

	if err != nil {
		t.Error("ERROR: The Authentication failed, error: ", err)
	} else {
		svc := s3.New(sess)

		result, err := svc.ListBuckets(&s3.ListBucketsInput{})
		if err != nil {
			t.Errorf("ERROR: %s", err)
		} else {
			for _, v := range result.Buckets {
				if strings.EqualFold(*v.Name, bucketId) {
					creation = true
				}
			}
		}
	}

	if creation {
		t.Log("OK: The S3 Bucket was created successfully!")
	} else {
		t.Error("FAIL: The S3 Bucket was not created")
	}
}

func getSNSConfigTest(t *testing.T, bucketId, expected string) {
	t.Log("Confirm the SNS configurations")

	var creation bool
	sess, err := getAuthorizer(t)

	if err != nil {
		t.Error("ERROR: The Authentication failed, error: ", err)
	} else {
		instance := getInfoResource(t, sess, bucketId)

		for _, v := range instance.TopicConfigurations {
			if strings.EqualFold(*v.TopicArn, expected) {
				creation = true
			}
		}

	}
	if creation {
		t.Log("OK: The SNS Topic was configured successfully")
	} else {
		t.Error("FAIL: The SNS Topic was not configure")
	}
}

func getLambdaConfigTest(t *testing.T, bucketId, expected string) {
	t.Log("Confirm the Lambda configurations")

	var creation bool
	sess, err := getAuthorizer(t)

	if err != nil {
		t.Error("ERROR: The Authentication failed, error: ", err)
	} else {
		instance := getInfoResource(t, sess, bucketId)

		if expected != "" {
			for _, v := range instance.LambdaFunctionConfigurations {
				if strings.EqualFold(*v.LambdaFunctionArn, expected) {
					creation = true
				}
			}
			if creation {
				t.Log("OK: The Lambda was configured successfully")
			} else {
				t.Error("FAIL: The Lambda was not configure")
			}
		} else {
			if len(instance.LambdaFunctionConfigurations) > 0 {
				t.Error("FAIL: Something happens: there are the lambda configurations")
			} else {
				t.Log("OK: The Lambda was not configure")
			}
		}

	}
}

func getQueueConfigTest(t *testing.T, bucketId, expected string) {
	t.Log("Confirm the Queue configurations")

	sess, err := getAuthorizer(t)
	var creation bool

	if err != nil {
		t.Error("ERROR: The Authentication failed, error: ", err)
	} else {
		instance := getInfoResource(t, sess, bucketId)

		if expected != "" {
			for _, v := range instance.QueueConfigurations {
				if strings.EqualFold(*v.QueueArn, expected) {
					creation = true
				}
			}
			if creation {
				t.Log("OK: The Queue was configured successfully")
			} else {
				t.Error("FAIL: The Queue was not configure")
			}
		} else {
			if len(instance.QueueConfigurations) > 0 {
				t.Error("FAIL: Something happens: there are the Queue configurations")
			} else {
				t.Log("OK: The Queue was not configure")
			}
		}
	}
}

func getInfoResource(t *testing.T, session *session.Session, id string) *s3.NotificationConfiguration {
	svc := s3.New(session)

	output, err := svc.GetBucketNotificationConfiguration(&s3.GetBucketNotificationConfigurationRequest{
		Bucket: aws.String(id),
	})

	if err != nil {
		t.Errorf("ERROR: %s", err)
	} else {
		return output
	}
	return nil
}

func getAuthorizer(t *testing.T) (*session.Session, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)
	return sess, err
}
