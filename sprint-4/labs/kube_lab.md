# Kubernetes Lab 🎱

# 1. Kubernetes exercise

### Instructions

Deploy the following in your AKS (Azure Kubernetes Service):

1. An nginx ingress controller that through the path /config /secret redirects you to a deployment where 2 pods are deployed with the image of ```gcr.io/google-samples/hello-app:1.0 ``` and makes use of a configmap (only configure an environment variable with a value taken from a configmap) and another deployment the same but consumes the data from a secret. (The /config redirect to the deployment with the configmap and the /secret to the deployment with the secret).


2. Deploy a kustomization that takes as resources everything deployed in point 1 but changes the google image tag to version 2 (```gcr.io/google-samples/hello-app:2.0```).


3. Replicate the horizontal auto scaling experiment seen in the class where with 20% of averageUtilization scale up to 5 pods. 
Can use the [traffic generator script](/sprint-4/kubernetes_extras/traffic-generator.sh)

## Learning materials

**Examples**

https://github.com/carloscatalanl/k8s-examples

**References**

- https://kubernetes.io/docs/tutorials/kubernetes-basics/ 
- https://kubernetes.io/docs/concepts/workloads/pods/ 
- https://kubernetes.io/docs/concepts/architecture/ 
- https://kubernetes.io/docs/concepts/services-networking/service/ 

**Optional**

Ilustrations

- https://cloud.google.com/kubernetes-engine/kubernetes-comic
- https://www.cncf.io/the-childrens-illustrated-guide-to-kubernetes/
- https://medium.com/tarkalabs/know-kubernetes-pictorially-f6e6a0052dd0 

Courses

- https://www.udemy.com/course/learn-kubernetes/
- https://www.udemy.com/course/kubernetesmastery/
- https://www.youtube.com/playlist?list=PL34sAs7_26wNBRWM6BDhnonoA5FMERax0 

Extras

- [Landscape](https://landscape.cncf.io)
- [DevOps periodic table](https://blog.xebialabs.com/2019/12/11/version-4-of-the-periodic-table-of-devops-tools-is-coming/ )
- [Additional PDFs](/sprint-4/kubernetes_extras/) 

