Pipeline: `eng-cloud-cicd`

Stage: `DeployPipelines`

Action: `Deploy`

Creates all the pipelines in this source code repo, including the ci_cd pipeline:

* eng-cloud-cicd
* tc-infra
* tc-<env_name>

Upon frst installation, these terraform scripts are executed as part of the `bootstrap.sh` script. Subsequent changes to the pipelines are automatically provisioned by the `eng-cloud-cicd` pipeline.
The pipeline structure like the sequence of stages is defined in the file `main.tf`, in the `codepipeline_*` modules.

