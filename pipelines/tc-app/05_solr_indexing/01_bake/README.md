Pipeline: `tc-app`

Stage: `BakeSolrIndexingImage`

Action: `BakeSolrIndexingImage`

Mounts the EBS snapshot created by the previous action and installs DeploymentCenter on top, then creates an AMI from that.

Prerequisites: EBS snapshot with TeamCenter software repository.
