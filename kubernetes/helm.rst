Installing with Helm
--------------------

See https://v3.helm.sh/docs/intro/using_helm/


Install helm v3 client https://v3.helm.sh/docs/intro/install/#from-the-binary-releases


The syntax is::

    helm install <releasename> <path-to-chart> [--values <values-file-path>] [--wait]

For example, for staging, the first time::

    helm install example-staging example --values values_staging.yaml --wait

After making changes, apply them with::

    helm upgrade example-staging example --values values_staging.yaml --wait

To *DESTROY* the deployed app (be careful!)::

    helm delete example-staging

("uninstall" works too.)
