## Configuring terratest for your repo:

- The root should contain a `.terratest` directory that contains all the Go folders with no subdirectories. 

- Terraform's root module (`main.tf`) should also be placed at the root of the repo.

- In `dwarf.config`, set TERRATEST=true   

# Terratest: Hello World!

Terratest uses Go's testing library to deploy and perform tests on Terraform provided infrastructure. 

***_Note:_*** By setting some flags like disabling auto-destroy, Terratest can be managed to work on existing infrastructure but this goes against [Terratest's best practices.](https://terratest.gruntwork.io/docs/testing-best-practices/testing-environment/)

- *Since most automated tests written with Terratest can make potentially destructive changes in your environment, we strongly recommend running tests in an environment that is totally separate from production. For example, if you are testing infrastructure code for AWS, you should run your tests in a completely separate AWS account.
[...]*


For a quick glance at how Terratest works, we will use a simple tf module that generates an output, and a Terratest go file that will test that the output contains the string "Hello World!".

To run Hello World test follow these steps:
1. `cd tests`
2. `go test terraform_helloworld_test.go -v -timeout 30m`

You should get the following output

```
--- PASS: TestTerraformHelloWorld (1.71s)
PASS
ok      command-line-arguments  2.331s
```


This repository contains multiple test examples that use Terraform modules to provide resources on AWS and Azure. 


# More Terratest Examples

## Description

Testing terratest devops tool chain using devops.ci-cd-ct repository
This repository contains some examples of Terratest with AWS and Azure as a cloud providers.

For running this locally, you must have configured AWS/Azure credentials in your environment. 

## How to use in your local environment

**_Note_**: You should have installed Go (golang) and Terraform

1. Clone this repo
   
2. Move to the 'test' folder. This contains the terratest test files. 

    `cd examples/tests`

3. Configure dependencies. Init the module with any name. 
   
    `go mod init "<MODULE NAME>"`

4. To run tests:

    ```
    // Run for files, example: terraform_helloworld_test.go
    go test <FILENAME>.go -v -timeout 30m

    $ go test terraform_aws_apache_test.go -v -timeout 30m

    // or you can run a specific function of a Go file
    go test -run TestTerraformHelloWorld -v -timeout 30m

    $ go test TestApacheIndexBod -v -timeout 30m
    ```


## Maintainers

- Sam Flint sam.flint@digitalonus.com

## Contributors

- Fernando Silva fernando.silva@digitalonus.com
- Arturo Rojas arturo.rojas@digitalonus.com
- Monserrat Guzman monserrat.guzman@digitalonus.com


## Useful Links

- [Terratest: Quick-Start](https://terratest.gruntwork.io/docs/getting-started/quick-start/)
- [Terratest: Best Practices](https://terratest.gruntwork.io/docs/#testing-best-practices)
- [Go: testing package](https://golang.org/pkg/testing/)
- [Go: Very complete tutorial for getting familiar with Go](https://www.youtube.com/watch?v=YS4e4q9oBaU)
 pr request should fail