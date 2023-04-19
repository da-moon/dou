Pipeline: `tc-app`

Stage: `BakeEnterpriseImage`

Action: `BakeEnterpriseImage`

Mounts the EBS snapshot created by the previous stage (bake_ebs_repo) and installs pakacge required, then creates an AMI from that.

Prerequisites: EBS snapshot with TeamCenter software repository.
