# Helm Lab ⎈

# 1. Lets make my own chart

### Instructions
- Create your first chart, using at least 2 different images (it can be your own Docker images).
- Use `helm create [CHART-DIRECTORY]`

Instead of the previous, you can modify some collection of K8s yaml; this should use a Load Balancer
service or any way to access the app (e. g. [ingress nginx controller](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx))

We encourage to try to modify the names of the variables in the `values.yaml`. Also, you could try
to delete all the files inside the `templates/` directory and erase the content of the `values.yaml`.

The final option is to:
- Create the Helm chart with `helm create [CHART-DIRECTORY]` (if you install this, it will provision 
a nginx server not accesible externally)
- Modify the content of `values.yaml`
    - replicaCount: from `0` to `5`
    - ingress.enabled: `True`
    - service.type: `NodePort`
- You can modify any other variable if you want and you know what it's going to happend
- Download the files of the ingress nginx controller into the `charts/` directory
    - `helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx`
    - `helm pull ingress-nginx/ingress-nginx --untar`
- Install the release:
    - `helm install [RELEASE-NAME] --create-namespace --namespace [NAMESPACE] [CHART-DIRECTORY]`


This are just suggestions. You are free to explore this or other options. You can contact your mentors
for any guidance.

## Contents
- [Introduction](/sprint-4/helm_extras/Introduction.md)    
- [Installing Helm](/sprint-4/helm_extras/Installing_Helm.md)
- [Using Helm](/sprint-4/helm_extras/Using_Helm.md)
- [Charts](/sprint-4/helm_extras/Charts.md)

## Learning materials
| Course | Materials |
| ----------- |-------------:|
| Helm Official Website | https://helm.sh/ |
| Cert-manager with Helm    | https://cert-manager.io/docs/installation/kubernetes/#installing-with-helm |

