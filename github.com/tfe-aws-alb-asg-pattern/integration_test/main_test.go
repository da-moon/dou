package test

import (
//"context"
//"os"
//"strings"
"testing"

//"github.com/gruntwork-io/terratest/modules/aws"
"github.com/stretchr/testify/assert"
//"github.com/gruntwork-io/terratest/modules/terraform"

"github.com/gruntwork-io/terratest/modules/terraform"
test_structure "github.com/gruntwork-io/terratest/modules/test-structure"

//test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestAlbAsg(t *testing.T) {
t.Parallel()

directory := "./"

test_structure.RunTestStage(t, "SETUP", func() {
terraformOptions := &terraform.Options{
TerraformDir: directory,
TerraformBinary: "/usr/bin/terraform13",
NoColor: true,
}
test_structure.SaveTerraformOptions(t, directory, terraformOptions)
terraform.InitAndApply(t, terraformOptions)
})

defer test_structure.RunTestStage(t, "TEARDOWN", func() {
terraformOptions := test_structure.LoadTerraformOptions(t, directory)
terraform.Destroy(t, terraformOptions)
})

test_structure.RunTestStage(t, "INTERNAL_TESTS", func() {
terraformOptions := test_structure.LoadTerraformOptions(t, directory)

// Get the Output
//lbId := terraform.Output(t, terraformOptions, "lb_id")
//lbArn := terraform.Output(t, terraformOptions, "lb_arn")
//asgName := terraform.Output(t, terraformOptions, "autoscaling_group_name")
//asgArn := terraform.Output(t, terraformOptions, "autoscaling_group_arn")
//asgLb := terraform.Output(t, terraformOptions, "autoscaling_group_load_balancers")
//asgTGArns := terraform.Output(t, terraformOptions, "autoscaling_group_target_group_arns")
//lbTGArns := terraform.Output(t, terraformOptions, "target_group_arns")
//region :=  terraform.Output(t, terraformOptions, "region")

desiredCapacity :=  terraform.Output(t, terraformOptions, "desired_capacity")
minCapacity :=  terraform.Output(t, terraformOptions, "min_size")
maxCapacity :=  terraform.Output(t, terraformOptions, "max_size")



t.Run("TestAsgCapacity", func(t *testing.T) {
asgCapacityTest(t, desiredCapacity, minCapacity, maxCapacity)//, asgName)
})

})

}

func asgCapacityTest(t *testing.T, desiredCapacity, minCapacity, maxCapacity string) {
t.Log("Confirm ASG capacity info")

if assert.Equal(t, desiredCapacity, string("2"), "FAIL: DesiredCapacity doesnt match") {
t.Log("OK: The Desired Capacity is 2")
}

if assert.Equal(t, minCapacity, string("2"), "FAIL: MinCapacity doesnt match") {
t.Log("OK: The Min Capacity is 2")
}

if assert.Equal(t, maxCapacity, string("2"), "FAIL: MaxCapacity doesnt match") {
t.Log("OK: The Max Capacity is 2")
}
}
