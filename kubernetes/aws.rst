Kubernetes on AWS
=================

If you have an EKS cluster on AWS and need to configure kubectl to talk to it:

* set AWS_DEFAULT_PROFILE to your aws profile name that can access that account/cluster
* You can list the clusters::

    aws eks list-clusters

* Run::

    aws eks update-kubeconfig --name <CLUSTERNAME>
