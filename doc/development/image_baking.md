# Image baking

We use [packer](https://www.packer.io) for creating the AMIs that the software needs to run. Packer is run from the terraform scripts of the individual stages, like in this example:

```
resource "null_resource" "packer" {
  # Rebake only if any of the input variables have changed, or the force_rebake flag is set
  triggers = {
    base_ami    = var.base_ami
    rebake_seed = local.rebake_seed
  }
  
  provisioner "local-exec" {
    working_dir = "${path.module}/../../../../../components/packer/tc_build_server/base"
    environment = {
      AWS_MAX_ATTEMPTS       = 180
      AWS_POLL_DELAY_SECONDS = 30
     }
    command = <<EOF
packer build \
  -var 'base_ami=${var.base_ami}' \
  -var 'build_uuid=${self.id}' \
  -machine-readable .

if [ ! $? -eq 0 ]; then
  echo "=== Packer Failed ==="
  exit 1
fi

EOF
  }
}
```

The tech stack sequence for running packer is then as follows:

1. CodeBuild runs the commands specified in the file `buildspec.yml` of the individual stage.
2. That file runs the script `run.sh`. This separation is needed to support in the future other CI implementations besides CodeBuild/CodePipeline.
3. The `run.sh` script runs the terraform scripts of that directory. Terraform is used instead of running packer directly from the shell script, so that we can read variables from other stages, and also is used as a mechanism to not run packer if none of the variables have changed, saving time by using terraform state to avoid running time consuming packer bakes when not needed.
4. Terraform runs packer using a `local-exec` provisioner.

