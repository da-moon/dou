variable "region" {
  description = "AWS region"
  type        = string
}

variable "service_account_name" {
  type        = string
  default     = "efs-csi-controller-sa"
  description = "Amazon EFS CSI Driver service account name."
}

variable "storage_class_name" {
  type        = string
  default     = "efs-sc"
  description = "Storage class name for EFS CSI driver."
}

variable "create_storage_class" {
  type        = bool
  default     = true
  description = "Whether to create Storage class for EFS CSI driver."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create k8s namespace with name defined by `namespace`."
}
variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to create k8s namespace with name defined by `namespace`."
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Amazon EKS namespace"
}

#helm variables for efs-csi-driver
variable "helm_chart_name" {
  type        = string
  default     = "aws-efs-csi-driver"
  description = "Amazon EFS CSI Driver chart name."
}

variable "helm_chart_release_name" {
  type        = string
  default     = "aws-efs-csi-driver"
  description = "Amazon EFS CSI Driver release name."
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  description = "Amazon EFS CSI Driver repository name."
}

variable "helm_chart_version" {
  type        = string
  default     = "2.2.0"
  description = "Amazon EFS CSI Driver chart version."
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/kubernetes-sigs/aws-efs-csi-driver."
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

##iam variables

variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "installation_prefix" {
  description = "A prefix to add to all resources created. Used to support multiple different installations of engineering in cloud."
  type        = string
}

##Cluster Variables
variable "cluster_name" {
  description = "Name of the the eks cluster"
  type        = string
  default     = "eks-tc"
}

variable "vpc_id" {
  description = "Identifier of the VPC where the resources are located"
}

variable "private_env_subnet_ids" {
  description = "IDs of the subnets where the build server runs"
  type        = list(string)
}

variable "instance_type" {
  description = "type of the instance"
  default     = ["m5.2xlarge"]
}

variable "min_size" {
  description = "type of the instance"
  default     = 2
}

variable "max_size" {
  description = "type of the instance"
  default     = 3
}

variable "desired_size" {
  description = "type of the instance"
  default     = 2
}

#### ALB controller and helm variables
variable "arn_format" {
  type        = string
  default     = "aws"
  description = "ARNs identifier, usefull for GovCloud begin with `aws-us-gov-<region>`."
}

variable "service_account_name_alb" {
  type        = string
  default     = "aws-alb-ingress-controller"
  description = "The kubernetes service account name."
}

variable "helm_chart_repo_alb" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "AWS Load Balancer Controller Helm repository name."
}

variable "helm_chart_release_name_alb" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "AWS Load Balancer Controller Helm chart release name."
}

variable "helm_chart_name_alb" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "AWS Load Balancer Controller Helm chart name."
}

variable "helm_chart_version_alb" {
  type        = string
  default     = "1.4.4"
  description = "AWS Load Balancer Controller Helm chart version."
}

## Variable to add EKS access to roles
variable "access_roles" {
  type = list(object({
    rolearn  = string,
    username = string,
    groups   = list(string)
  }))
}

variable "namespace_kube" {
  type        = string
  description = "env-kube namespace for deployment scripts"
}
