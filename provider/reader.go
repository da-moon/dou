package provider

import (
	"io"
	"os"

	c "github.com/DigitalOnUS/tf-coverage/common"
	"github.com/DigitalOnUS/tf-coverage/provider/aws"
)

// ResourceReader from template file or from cloud provider
type ResourceReader interface {
	Read(string) ([]c.Resource, error)
	GenerateReport([]c.Resource) (io.Reader, error)
}

type FuncGen func(bool) ResourceReader

var Supported = map[string]FuncGen{
	"AWS": func(runtime bool) ResourceReader {
		return &aws.AWS{
			Profile: os.Getenv(aws.AWSPROFILE),
			Runtime: runtime,
		}
	},
}
