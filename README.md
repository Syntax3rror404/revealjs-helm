# reveal-js inside kubernetes!
 This Helm Chart deploys Reveal.js presentations using Nginx within a Kubernetes cluster, offering flexibility to host multiple presentations and allowing customization through ConfigMaps.

## Deploy on kubernetes cluster
This part is currently work in progress. Please wait ...

## Local testing with image
The Contaienr image are located at ghcr.
With this example command, you can pull the image to you local env:
```
nerdctl run ghcr.io/syntax3rror404/revealjs-helm/revealjs:latest
```

## Local testing with helm
```
# Create your values file, if you want to override the default settings
# Test helm deployment:
helm install reveal . --create-namespace -n reveal -f ../../youvalues.yaml
helm uninstall reveal -n reveal
```