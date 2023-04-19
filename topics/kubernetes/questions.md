## Kubernetes Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![Kubernetes Cheat Sheet-1](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/kubernetes-cheat-sheet-1.png)
![Kubernetes Cheat Sheet](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/kubernetes-cheat-sheet-2.png)

### Questions

- **Basic questions**:
    - What are nodes in kubernetes?
        + A node is a type of work machine in Kubernetes that was previously known as a minion. A node can be a type of virtual machine or the physical machine. It always depends upon the clusters. Each of the nodes provides the services that are necessary to run pods, and it is also managed by the master components.
    - How would you see the status of all nodes?
        + `kubectl get nodes command`
    - What are pods in Kubernetes?
        + A Kubernetes pod is a group of containers that are being deployed in the same host. Pods have the capacity to operate one level higher than the individual containers. This is because pods have the group of containers that work together to produce an artefact or to process a set of work.

    - What are namespaces in Kubernetes?
        + Kubernetes is especially intended for the use of the environments with many other users that are being spread across multiple teams or projects. Namespaces are the way to divide the cluster resources between the multiple users.
    - What are the initial namespaces from which the Kubernetes starts?
        + The followings are the three initial namespaces from which the Kubernetes starts:
            * Default
            * Kube – system
            * Kube – public
    - What is minikube?
        + Minikube is a type of tool that makes the Kubernetes easy to run locally. Minikube basically runs on the single nodes Kubernetes cluster that is inside the virtual machine on your laptop. This is also used by the developers who are trying to develop by using Kubernetes day to day.


    - What are the different components of Kubernetes Architecture?
        + The Kubernetes Architecture has mainly 2 components – the master node and the worker node. As you can see in the below diagram, the master and the worker nodes have many inbuilt components within them. The master node has the kube-controller-manager, kube-apiserver, kube-scheduler, etcd. Whereas the worker node has kubelet and kube-proxy running on each node.
        ![Kubernetes Architecture](https://github.com/DigitalOnUs/devops_interviews/blob/master/topics/kubernetes/k8-components.png)

    - Explain all the components:
        + Executor node (worker node): (This runs on master node)
            * Kube-proxy: This service is responsible for the communication of pods within the cluster and to the outside network, which runs on every node. This service is responsible to maintain network protocols when your pod establishes a network communication.
            * kubelet: Each node has a running kubelet service that updates the running node accordingly with the configuration(YAML or JSON) file. NOTE: kubelet service is only for containers created by Kubernetes.
        + Master services (master node):
            * Kube-apiserver: Master API service which acts as an entry point to K8 cluster.
            * Kube-scheduler: Schedule PODs according to available resources on executor nodes.
            * Kube-controller-manager:  is a control loop that watches the shared state of the cluster through the apiserver and makes changes attempting to move the current state towards the desired stable state.
            * etcd: is a consistent and highly-available key value store used as Kubernetes' backing store for all cluster data.
    - What is a service in kubernetes?
        + A Service in Kubernetes is an abstraction which defines a logical set of Pods and a policy by which to access them. Services enable a loose coupling between dependent Pods. A Service is defined using YAML (preferred) or JSON, like all Kubernetes objects.
    - How would you package kubernetes applications?
        + Helm is a package manager which allows users to package, configure, and deploy applications and services to the Kubernetes cluster.
    - What is the difference between deployment and daemon set?
        + Daemonset: is a kind of deployment that will ensure one pod per node (useful for monitoring angents or services that needs to run in each node), 
        + Deployment: You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate.

- **Advance questions**:
    - What are the different types of services being provided by Kubernetes?
        + 'The followings are the different types of services being provided by the Kubernetes:
            * Cluster IP
            * Node Port
            * Load Balancer
            * External name
    - How should you connect an app pod with a database pod?
        + By using a service object. reason being, if the database pod goes away, it's going to come up with a different name and IP address.  Which means the connection string would need to be updated every time, managing that is difficult. The service proxies traffic to pods and it also helps in load balancing of traffic if you have multiple pods to talk to. It has its own IP and as long as service exists pod referencing this service in upstream will work and if the pods behind the service are not running, a pod will not see that and will try to forward the traffic but it will return a 502 bad gateway.So just defined the Service and then bring up your Pods with the proper label so the Service will pick them up.
    - What is deployed on the kube-system namespace?
        + kube-system is the namespace for objects created by the Kubernetes system. Typically, this would contain pods like kube-dns , kube-proxy , kubernetes-dashboard and stuff like fluentd, heapster, ingresses and so on.
    - How to configure a default ImagePullSecret for any deployment?
        + You can attach an image pull secret to a service account. Any pod using that service account (including default) can take advantage of the secret.you can bind the pullSecret to your pod, but you’re still left with having to create the secret every time you make a namespace.
    - If you have a pod that is using a ConfigMap which you updated, and you want the container to be updated with those changes, what should you do?
        + If the config map is mounted into the pod as a volume, it will automatically update not instantly and the files will change inside the container. If it is an environment variable it stays as the old value until the container is restarted.
    - If you try to delete a namespace and when running the command it gets hung? What is your troubleshoot procedure?
        + `kubectl delete -f <ns>` --> delete resources inside ns and try again --> get the out put of the ns as json, store it as a file, modify the finalizer block and apply the yaml.
    - Tell me one pattern to use when etcd requires to be HA.
        + Stacked or external topology.
    - What is the difference between stacked and external topology?
        + With stacked control plane nodes, where etcd nodes are colocated with control plane nodes and with external etcd nodes, where etcd runs on separate nodes from the control plane.
    - How do you rollback a deployment?
        + `kubectl rollout undo <deployment>`
    - How to configure default memory requests and limits for a namespace?
        + Using LimitRange.
    - How to set quotas for the total amount memory and CPU that can be used by all ontainers running in a namespace?
        + Creating a PodDisruptionBudget (PDB) for each application.
    - Why is important to implement a rollingupdate strategy?
        + This help to minimize impacts when deploying new releases.
    - When configuring the image pull policy why you will set always instead never?
        + All depends on the deployment design and how you are serving your images to your cluster, if your deployment doesn't have a pre-pull strategy you should never use the "never" option.

