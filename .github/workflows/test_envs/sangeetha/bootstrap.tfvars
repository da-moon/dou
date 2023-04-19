bootstrap_bucket_name     = "sangeetha-central-test"  # AWS S3 bucket name where terraform state files will be stored.
bootstrap_region          = "ca-central-1"            # AWS region where bootstrap components will be installed, like any CI/CD and state files.
vcs_provider              = "codecommit"              # Indicates what VCS provider should be used to store the infrastructure as code. Currently only "codecommit" is supported.
vcs_reponame              = "techm-engineering-cloud" # Name of the git repository that will host all the infrastructure as code
teamcenter_enabled        = true                      # Whether or not TeamCenter will be installed
installation_prefix       = "gc4"                     # A prefix to add to all resources created. Used to support multiple different installations of engineering in cloud.
teamcenter_s3_bucket_name = "teamcenter-eic"          # teamcenter bucket