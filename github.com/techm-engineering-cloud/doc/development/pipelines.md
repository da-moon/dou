# Pipelines development

## Pipelines structure

Pipelines are stored in the `pipelines` folder. The subfolders with numeric prefixes represent individual stages in a pipeline, and are used to easily see the intended sequence in which they are run.

Each numeric folder has contents similar to this:

* `buildspec.yml`: File used by AWS CodeBuild that contains the sequence of shell commands to execute. Usually this file only installs the required tools like terraform and packer, and runs the `run.sh` script.
* `run.sh`: Script to be run for the stage. Usually it just reads the correct terraform variables and runs the terraform scripts.
* `main.tf`: If present, it's the main file for the terraform scripts to execute in the stage.
* `variables.tf`: If present, contains the variables required by the terraform scripts to run.

The actual terraform scripts that provision CodeBuild projects and CodePipeline pipelines are in `pipelines/bootstrap/main.tf`, so when adding, removing or changing pipelines you may need to look at the approapriate changes there.

## How to run pipelines

There are different ways in which pipelines can be run:

* Automatically from CodePipeline when trigger conditions are met, like pushing changes to the CodeCommit repository. This is the standard and usual way to run the pipelines because it's fully automated without user intervention.
* Manually from CodePipeline. You can manually start any pipeline from AWS Management Console.
* Run individual stages from AWS CodeBuild. Sometimes you may want to run individual stages, and each stage is represented as a CodeBuild project. You can run any individual CodeBuild project from AWS Management Console.
* Run individual stages locally from a laptop. Typically used during development or for quickly testing things out, you can go to the folder under `pipelines` you want to execute and run the `run.sh` script.

Stages are designed to be **idempotent** whenever possible, which means that the same stage can be run multiple times without unwanted effects. Since most of them use terraform, running a stage a second time usually does nothing.


