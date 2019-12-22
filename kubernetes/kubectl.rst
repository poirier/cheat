Kubectl
=======

* Kubectl cheatsheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration

* Is kubectl installed? ``kubectl version``
* View cluster details: ``kubectl cluster-info``
* View nodes: ``kubectl get nodes``

* Create namespace: ``kubectl create namespace tobias``
* Set default namespace: ``kubectl config set-context --current --namespace=tobias``
* Use the kubectl create command to create a Deployment that manages a Pod. The Pod runs a Container based on the provided Docker image.::

    kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node

* View deployment: ``kubectl get deployments``
* View pods: ``kubectl get pods``
* View cluster events: ``kubectl get events``
* View kubectl config: ``kubectl config view``
* Expose the Pod to the public internet using the kubectl expose command::

    kubectl expose deployment hello-node --type=LoadBalancer --port=8080

* View services: ``kubectl get services``

On cloud providers that support load balancers, an external IP address would be provisioned to access the Service. On Minikube, the LoadBalancer type makes the Service accessible through the minikube service command.

* Clean up::

    kubectl delete service hello-node
    kubectl delete deployment hello-node


Find out the hostname & IP address of something deployed
--------------------------------------------------------

Use::

    kubectl get ingress --all-namespaces

Setting up DNS
--------------

See what the IP address of the nginx ingress controller is by
running::

    kubectl get Service --namespace=ingress-nginx

Configure your hostname to point at the External IP address shown
by this command, even if it differs from the external IP that might
be shown with your app's ingress. You want this one, not that one.
