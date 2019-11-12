Let K8S access a private docker registry
----------------------------------------

(Note: it can be simpler to use a registry provided by your K8S host, e.g.
Google's Container Registry.)

https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

* Locally, "docker login" to your registry.
* Optionally, edit ~/.docker/config.json to temporarily remove any information about
  registries other than the one you want to grant access to.
* Run run "base64 -w0 <~/.docker/config.json" and save the output.
* Define a secrets file like this, replacing the value of ".dockerconfigjson"
  with the output from the previous command::

    apiVersion: v1
    kind: Secret
    metadata:
      name: registry-secret
      namespace: "{{ .Release.Name }}"
    data:
      .dockerconfigjson: "xxxx=="
    type: kubernetes.io/dockerconfigjson

* In your deployment, set "spec.template.spec.imagePullSecrets" to ["registry-secret"].

