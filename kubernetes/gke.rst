KUBERERNETES on GKE with HELM
=============================

GKE is Google's hosted Kubernetes environment.

Install Helm v3
---------------

Install helm v3 client https://v3.helm.sh/docs/intro/install/#from-the-binary-releases

At this time (Nov. 2019), Helm v3 is still in beta but it seems pretty stable.
It has the great advantage over Helm v2 that there's no Tiller running in the K8S
cluster anymore.

The v3 docs don't seem quite complete yet, but for the most part, the v2 docs
still apply.

Setting up the cluster
----------------------

* Create a cluster if there's not one already. See e.g. https://github.com/caktus/gcp-web-stacks
  or https://docs.ansible.com/ansible/latest/modules/gcp_container_cluster_module.html
* Ensure your kubectl context is set to that cluster. See e.g.
  https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/
  Running `kubectl cluster-info` should show the GKE cluster's information.
* Add an nginx ingress controller and letsencrypt to the cluster if not already set up.
  See https://github.com/caktus/caktus-hosting-services/blob/master/Ansible/README.rst

  You can see if a controller already exists by running `kubectl get service --namespace=ingress-nginx`.
  It'll show up as a LoadBalancer.

  You can see if Lets Encrypt is set up by running `kubectl get ClusterIssuer --all-namespaces`.
  You will probably see two objects named "letsencrypt-production" and
  "letsencrypt-staging".

Docker registry
---------------

Google provides a docker registry we can use, with some setup.  You'll need to know
the Google Cloud Platform Console Project ID.  Then you can follow these instructions
to push images to the registry that won't be public, but that your cluster will
be able to access.

* Run `gcloud auth configure-docker`. This will update your .docker/config.json
  file to tell docker to work through gcloud to authenticate you for the google
  docker registries only.
  https://cloud.google.com/container-registry/docs/advanced-authentication#gcloud_as_a_docker_credential_helper
* You should already be authenticated to Google cloud from previous steps.
* Tag your images using "us.gcr.io/PROJECTID/imagename:LABEL"
* Now you should be able to push them: `docker push us.gcr.io/PROJECTID/imagename:LABEL`.
  https://cloud.google.com/container-registry/docs/pushing-and-pulling

Installing with Helm
--------------------

See https://v3.helm.sh/docs/intro/using_helm/

The syntax is::

    helm install <releasename> <path-to-chart> [--values <values-file-path>] [--wait]

For example, for staging, the first time::

    helm install example-staging example --values values_staging.yaml --wait

After making changes, apply them with::

    helm upgrade example-staging example --values values_staging.yaml --wait

To *DESTROY* the deployed app (be careful!)::

    helm delete example-staging

("uninstall" works too.)

Setting up DNS
--------------

See what the hostname and address of the load balancer are:

  `kubectl get ingress --all-namespaces`

If there are no IP addresses shown, it's possible the cluster has not yet been set up
for nginx etc.  Go back and follow the instructions about caktus-hosting-services
again.

Now set the domain name to point to that IP address. (You can just do it in your
local /etc/hosts file if just testing.)
