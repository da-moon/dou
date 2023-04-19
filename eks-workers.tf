data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.demo.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.demo.endpoint}' --b64-cluster-ca '${aws_eks_cluster.demo.certificate_authority[0].data}' '${var.cluster-name}'
USERDATA

}

resource "aws_launch_configuration" "demo" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.demo-node.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = var.instance_type
  name_prefix                 = var.cluster-name
  security_groups             = [aws_security_group.demo-node.id]
  user_data_base64            = base64encode(local.demo-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo" {
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.demo.id
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.cluster-name}-test"

  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibilty in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.

  #vpc_zone_identifier         = aws_subnet.plm_public[*].id
  vpc_zone_identifier = [aws_subnet.plm_private[0].id, aws_subnet.plm_private[1].id, aws_subnet.plm_private[2].id]

  tag {
    key                 = "Name"
    value               = var.cluster-name
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}