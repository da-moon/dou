package aws

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"path/filepath"
	"reflect"
	"strings"

	c "github.com/DigitalOnUS/tf-coverage/common"
	"github.com/aws/aws-sdk-go-v2/aws/external"
	"github.com/aws/aws-sdk-go-v2/service/cloudformation"
	"github.com/pitakill/aws_resources"
)

const (
	AWSPROFILE = "AWS_PROFILE"
)

// AWS placeholder
type AWS struct {
	Profile string
	Runtime bool
}

// Read placeholder
func (aws *AWS) Read(stack string) (list []c.Resource, err error) {

	// Runtime use case
	if aws.Runtime {
		if aws.Profile == "" {
			err = errors.New("set the AWS_PROFILE env variable to get info from runtime")
			return
		}

		log.Println("loading config for aws profile")
		config, configErr := external.LoadDefaultAWSConfig(
			external.WithSharedConfigProfile(aws.Profile),
		)

		if configErr != nil {
			err = configErr
			return
		}

		aws_resources.SetConfig(config)

		cfConfig := &aws_resources.CloudFormationTypeConfig{
			StackStatus: []cloudformation.StackStatus{
				cloudformation.StackStatusCreateComplete,
			},
			StackName: stack,
		}

		iCF := aws_resources.Relations["cloudformation"](config)

		if err = iCF.Configure(*cfConfig); err != nil {
			return
		}

		if _, err = iCF.GetServices(); err != nil {
			return
		}

		// If there is no resources there is not pretty much we could do
		if err = iCF.GetResources(); err != nil {
			return
		}

		var res []reflect.Value

		res, err = iCF.GetResourcesDetail()

		if err != nil {
			return
		}

		log.Println(len(res))
		log.Println(res)

		for _, e := range res {
			if !e.IsValid() {
				continue
			}

			var pkg, structure string

			if e.Kind() == reflect.Ptr {
				structure = e.Elem().Type().Name()

				path := e.Elem().Type().PkgPath()
				pathSplitted := strings.Split(path, string(filepath.Separator))
				pkg = pathSplitted[len(pathSplitted)-1]
			}

			var t []byte

			t, err = json.Marshal(e.Interface())
			if err != nil {
				return
			}

			resourceType := fmt.Sprintf("%s.%s", pkg, structure)
			list = append(list, c.Resource{
				Type: resourceType,
				Name: string(t),
			})

		}

	}

	return
}

// GenerateReport placeholder
func (aws *AWS) GenerateReport(list []c.Resource) (io.Reader, error) {
	return nil, nil
}
