Minikube
--------

https://kubernetes.io/docs/tutorials/hello-minikube/

* Start minikube: ``minikube start``
* Open dashboard in a browser: ``minikube dashboard``
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

* Make avail on minikube: ``minikube service hello-node``

* Clean up::

    kubectl delete service hello-node
    kubectl delete deployment hello-node
    minikube stop
    minikube delete

https://kubernetes.io/docs/tutorials/kubernetes-basics/
https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-intro/

* Is minikube installed? ``minikube version``
* Start it: ``minikube start`` (wait... wait...)
* Is kubectl installed? ``kubectl version``
* View cluster details: ``kubectl cluster-info``
* View nodes: ``kubectl get nodes``

https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-intro/
https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-interactive/
