package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestTerraformCaaSCode(t *testing.T) {
	t.Parallel()

	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/terraform_code/terraform_azure_check_body/")

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

		// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)

		testCheckBody(t, terraformOptions)
	})
}

func testCheckBody(t *testing.T, terraformOptions *terraform.Options) {
	// Run `terraform output` to get the IP of the instance
	nginxIP := terraform.Output(t, terraformOptions, "public_ip_address")
	//fargate_lb_dns := terraform.Output(t, terraformOptions, "ecs_aws_elb_public_dns")

	// Make an HTTP request to the instance and make sure we get back a 200 OK with the body "Hello, World!"
	nginxURL := fmt.Sprintf("http://%s:80", nginx_ip)

	http_helper.HttpGetWithRetryWithCustomValidationE(t, nginx_url, nil, 30, 5*time.Second, func(status int, content string) bool {
		return status == 200 && strings.Contains(content, "nginx")
	})
}
