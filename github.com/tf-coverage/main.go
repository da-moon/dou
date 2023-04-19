package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	clouds "github.com/DigitalOnUS/tf-coverage/provider"
)

// Usage
// tf-coverage <provider> <stack names> -runtime

var (
	provider string
	runtime  bool
	stacks   []string
)

func init() {
	// provider
	flag.StringVar(&provider, "provider", "", "specify cloud provider")
	flag.BoolVar(&runtime, "runtime", false, "runtime means get the info from the cloud provider directly")

}

func main() {
	flag.Parse()
	stacks = flag.Args()

	if len(stacks) < 1 {
		fmt.Println("please provide the list of stacks or template files to analyze")
		os.Exit(1)
	}

	gen, ok := clouds.Supported[provider]

	if !ok {
		fmt.Println("cloud provider not supported, please use -provider ")
		for supported := range clouds.Supported {
			fmt.Printf("* %s\n", supported)
		}
		os.Exit(1)
	}

	worker := gen(runtime)

	for _, stack := range stacks {
		log.Println(stack)
		resources, err := worker.Read(stack)
		if err != nil {
			log.Println(err)
			continue
		}

		log.Printf("%+v\n", resources)

		_, err = worker.GenerateReport(resources)

		if err != nil {
			log.Println(err)
			continue
		}

	}
}
