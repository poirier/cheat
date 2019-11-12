Kubernetes
==========

Contents:

.. toctree::
   :maxdepth: 2

   docker_registry
   minikube
   digital_ocean
   gke


Misc. notes
-----------

* Login to google cloud (change parms)::

    gcloud auth login
    gcloud beta container clusters get-credentials kubedemo-cluster --region us-east1 --project kubernetes-lighting-talk
    kubectl cluster-info

* Create namespace: ``kubectl create namespace tobias``
* Set default namespace: ``kubectl config set-context --current --namespace=tobias``

Find out the hostname & IP address of something deployed
--------------------------------------------------------

Use::

    kubectl get ingress --all-namespaces
