Kubernetes Dashboard
====================

https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

Getting to it
--------------

Start this running somewhere you can leave it running::

    kubectl proxy

Now go to `http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ <http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/>`_.

Logging in
-----------

Run this to get a token::

    kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

Then paste it where specified.
