Digital Ocean
-------------

If you have a cluster on DO, here's how to access it locally.

1. Locally, install kubectl https://kubernetes.io/docs/tasks/tools/install-kubectl/
1. Locally, install doctl https://github.com/digitalocean/doctl (`sudo snap install doctl`)
1. Locally, link doctl to kubectl (`sudo snap connect doctl:kube-config`)
1. Locally, authenticate to DO with doctl
   1. Get a token at https://cloud.digitalocean.com/account/api/tokens
   1. Copy the token into the clipboard
   1. Run `doctl auth init` and paste the token when prompted
1. Locally, auth to DO (https://www.digitalocean.com/docs/kubernetes/how-to/connect-to-cluster/)
   e.g. `doctl kubernetes cluster kubeconfig save example-cluster-01`

Now you should be able to use kubectl to work with the cluster.
See also
https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/
