package test

import (
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"testing"
	"time"

	"github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2019-07-01/compute"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"golang.org/x/crypto/ssh"
)

func TestCompute(t *testing.T) {
	t.Parallel()

	directory := "../../examples/terraform_code/terraform_azure_compute/"

	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := &terraform.Options{
			TerraformDir: directory,
		}

		test_structure.SaveTerraformOptions(t, directory, terraformOptions)
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, directory)
		// outputs
		resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
		vmName := terraform.Output(t, terraformOptions, "vm_name")
		publicIP := terraform.Output(t, terraformOptions, "ip_public_vm")
		// functions
		GetRegionOnAzureTest(t, terraformOptions)
		SizeOnVirtualMachineTest(t, terraformOptions, resourceGroupName, vmName)
		ContainTagsTest(t, terraformOptions, resourceGroupName, vmName)
		GetHTTPCodeTest(t, terraformOptions, publicIP)
		ConnectionSSHandGetPackagesTest(t, terraformOptions, publicIP)
		PortsOpenTest(t, terraformOptions, publicIP)
	})

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, directory)
		terraform.Destroy(t, terraformOptions)
	})

}

func GetRegionOnAzureTest(t *testing.T, terraformOptions *terraform.Options) {
	// TEST #1 - Check region exits
	actualVMRegion := azure.GetAllAzureRegions(t, "")
	assert.Contains(t, actualVMRegion, "southcentralus")
}

func SizeOnVirtualMachineTest(t *testing.T, terraformOptions *terraform.Options, resourceGroupName, vmName string) {
	// TEST #2 - Look up the size of the given vm
	actualVMSize := azure.GetSizeOfVirtualMachine(t, vmName, resourceGroupName, "")
	expectedVMSize := compute.VirtualMachineSizeTypes("Standard_DS1_v2")
	assert.Equal(t, expectedVMSize, actualVMSize)
}

func ContainTagsTest(t *testing.T, terraformOptions *terraform.Options, resourceGroupName, vmName string) {
	// TEST #3 - Check the tags on vm

	TagPrefix := "environment"

	actualVMTags := azure.GetTagsForVirtualMachine(t, vmName, resourceGroupName, "")
	if assert.NotEmpty(t, actualVMTags) {
		assert.Contains(t, actualVMTags, TagPrefix)
	}
}

func GetHTTPCodeTest(t *testing.T, terraformOptions *terraform.Options, publicIP string) {
	// TEST #4 - Check IP is working
	myHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/" {
			return
		}
	})
	assert.HTTPStatusCode(t, myHandler, "GET", publicIP, nil, 200)
}

func ConnectionSSHandGetPackagesTest(t *testing.T, terraformOptions *terraform.Options, publicIP string) {
	// TEST #6 - SSH to the vm
	sshConfig := &ssh.ClientConfig{
		User:            "testadmin",
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
		Auth: []ssh.AuthMethod{
			ssh.Password("Password1234!"),
		},
	}
	connection, err := ssh.Dial("tcp", publicIP+":22", sshConfig)
	if err != nil {
		log.Fatalf("unable to connect: %s", err)
	} else {
		assert.Empty(t, err)
	}
	defer connection.Close()

	// TEST #7 - Check one package is installed
	session, errSession := connection.NewSession()
	if errSession != nil {
		log.Fatalf("Failed to create session: %s", errSession)
	} else {
		stdin, errSession := session.StdinPipe()
		if err != nil {
			log.Fatal(err)
		}

		session.Stdout = os.Stdout
		session.Stderr = os.Stderr

		// Start remote shell
		errSession = session.Shell()
		if errSession != nil {
			log.Fatal(errSession)
		}

		// send the commands
		commands := []string{
			"apache2 -v",
			"exit",
		}
		for _, cmd := range commands {
			_, errSession = fmt.Fprintf(stdin, "%s\n", cmd)
			if errSession != nil {
				log.Fatal(errSession)
			}
		}

		// Wait for sess to finish
		errSession = session.Wait()
		if errSession != nil {
			log.Fatal(errSession)
		}
		assert.Empty(t, errSession)
	}
	defer session.Close()
}

func PortsOpenTest(t *testing.T, terraformOptions *terraform.Options, publicIP string) {
	// TEST #8 - Check ports open
	timeout := time.Second
	conn, errConn := net.DialTimeout("tcp", net.JoinHostPort(publicIP, "22"), timeout)

	if conn != nil {
		defer conn.Close()
	} else {
		assert.Empty(t, errConn)
	}
}
ssh terratest@20.46.233.102
Passw0rd123!

