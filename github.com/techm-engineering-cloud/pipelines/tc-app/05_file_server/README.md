Pipeline: `tc-app`

Stage: `BakeFileServerImage`

Action: `BakeFileServerImage`

Mounts the EBS snapshot created by the previous action and installs DeploymentCenter on top, then creates an AMI from that.

Prerequisites: EBS snapshot with TeamCenter software repository.
