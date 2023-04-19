package test

import (
	"crypto/tls"
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

// An example of how to test the Terraform module in examples/terraform-azure-apache using Terratest. The test also
// shows an example of how to break a test down into "stages" so you can skip stages by setting environment variables
// (e.g., skip stage "teardown" by setting the environment variable "SKIP_teardown=true"), which speeds up iteration
// when running this test over and over again locally.
func TestApacheIndexBody(t *testing.T) {
	t.Parallel()

	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/terraform_code/terraform_aws_apache/")

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)
		terraform.Destroy(t, terraformOptions)
	})

	// Deploy the example
	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := configureTerraformOptions(t, exampleFolder)

		// Save the options and key pair so later test stages can use them
		test_structure.SaveTerraformOptions(t, exampleFolder, terraformOptions)

		//test_structure.SaveEc2KeyPair(t, exampleFolder, keyPair)

		// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	})

	// Make sure we can SSH to the public Instance directly from the public Internet and the private Instance by using
	// the public Instance as a jump host
	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)

		testWebserverIndex(t, terraformOptions)
	})

}

// Variables that need assignment for the terraform module are configured here.
func configureTerraformOptions(t *testing.T, exampleFolder string) *terraform.Options {
	uniqueID := random.UniqueId()

	// Give this EC2 Instance and other resources in the Terraform code a name with a unique ID so it doesn't clash
	// with anything else in the AWS account
	prefix := fmt.Sprintf("test-apache-%s", uniqueID)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: exampleFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"prefix": prefix,
		},
	}

	return terraformOptions
}

// Tests the webserver to match an expected HTML body with the body found in the server's index.
func testWebserverIndex(t *testing.T, terraformOptions *terraform.Options) {

	// Get the instance's assigned DNS through the configured terraform output
	webserverDNS := "http://" + terraform.Output(t, terraformOptions, "DNS")

	// Expected http body to be found in the webserver
	expectedBody := "<p> My Instance! </p>"

	// A TLS config, even if empty, is a required parameter for the GET function
	config := &tls.Config{}

	maxRetries := 3
	timeBetweenRetries := 15 * time.Second
	description := fmt.Sprintf("Making GET Request to url %s", webserverDNS)

	//Apache2 server may take some time to get up after the terraform deployment,
	//so the test will be retried a couple times
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualResponse, actualBody, err := http_helper.HttpGetE(t, webserverDNS, config)

		// If HttpGetE returns an error, display it and fail the test
		if err != nil {
			return "", err
		}

		// If the body doesn't match, fail the test
		if expectedBody != actualBody {
			return "", fmt.Errorf("Expected index body '%s' not found.  Found '%s' instead. Response: %c", expectedBody, actualBody, actualResponse)
		}

		// Body matched, test OK and return nil error
		return "", nil
	})
}
