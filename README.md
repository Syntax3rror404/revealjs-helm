# reveal-js inside kubernetes!
This Helm Chart deploys Reveal.js presentations and server using Nginx within a Kubernetes cluster, offering flexibility to host multiple presentations and allowing customization through ConfigMaps.

It allows the installation of revealjs as a server into a Kubernetes cluster and enables for example direct editing of one or more HTML or Markdown files as a ConfigMap, adding them as a Kubernetes resource.

The container is based on the nginx container, with the revealjs tarball simply unpacked into the nginx container. The ConfigMap is unpacked into /usr/share/nginx/html/slides. The Helm chart also supports specifying existing or custom ConfigMaps with configurable mount points.

For example, it is possible to call Markdowns from a git directly as remote Markdown and much more.

## How to use
Installed you have a revealjs server based on Nginx installed and you can use them over ingress, portforwarding with kubectl etc.

The Nginx is configured to ignore the index.html files, to force the "autoindex" filebrowser from nginx to show up, so you can select you presentation slide html without the need to write the path as url.

In best case, you can store the md files in git or s3. Then you can use reveal js to pull the md files from remote:

Example:
```
<section data-markdown="https://raw.githubusercontent.com/user/repo/branch/intro.md"
        data-separator="^--"
        data-separator-vertical="^\n\n"
        data-separator-notes="^Note:"
        data-charset="utf-8">
</section>
```

### Upload slides over helm deployment
To add slides via helm values, you need set `configMap.enabled: true 

After that you can add as much html files as you want. For example:
```
configMap:
  enabled: true
  presentations:
    example1.html: |
      [HTML]
    example2.html: |
      [HTML]
    example3.html: |
      [HTML]
```

### Upload slides with your own config maps
If you dont want, to upload or configure you slides over helm, you can also add your own config maps and you can refer there to automaticly mount them to your container: 
```
existingConfigMaps:
  - name: mypresentation
    mountPath: /usr/share/nginx/html/mypresentation
  - name: mybetterpresentation
    mountPath: /usr/share/nginx/html/mybetterpresentation
```

## Deploy on kubernetes cluster (documentation wip)
You can create your own values file with the html files included. The helm chart creates in this example the config mount by itself:
```
1. Installing with default values inside reveal namespace:
helm install revealjs . --create-namespace -n revealjs

2. Installing with your own values inside reveal namespace:
helm install revealjs . --create-namespace -n revealjs -f ../../yourvalues.yaml

3. You can also uninstalling it, after your presentation:
helm uninstall revealjs -n revealjs
```

## Deploy with ArgoCD with html embedded slides configmap
This is a example how to deploy this app with ArgoCD

<details><summary><b>ArgoCD Application Manifest example (click here)</b></summary>

```
project: default
source:
  repoURL: 'https://github.com/Syntax3rror404/revealjs-helm.git'
  path: helm
  targetRevision: HEAD
  helm:
    values: |
      configMap:
        enabled: true
        presentations:
          remotemarkdown.html: |
            <!doctype html>
            <html>
              <head>
                <meta charset="utf-8">
                <title>Remote markdown presentation</title>
                <link rel="stylesheet" href="../dist/reveal.css">
                <link rel="stylesheet" href="../dist/theme/black.css" id="theme">
                <!-- Theme used for syntax highlighting of code -->
                <link rel="stylesheet" href="../plugin/highlight/monokai.css" id="highlight-theme">
              </head>
              <body>
                <div class="reveal">
                  <div class="slides">
                    <section data-markdown="https://raw.githubusercontent.com/user/repo/branch/intro.md"
                            data-separator="^--"
                            data-separator-vertical="^\n\n"
                            data-separator-notes="^Note:"
                            data-charset="utf-8">
                    </section>

                    <section data-markdown="https://raw.githubusercontent.com/user/repo/branch/example.md"
                            data-separator="^--"
                            data-separator-vertical="^\n\n"
                            data-separator-notes="^Note:"
                            data-charset="utf-8">
                    </section>
                  </div>
                </div>

                <script src="../dist/reveal.js"></script>
                <script src="../plugin/markdown/markdown.js"></script>
                <script src="../plugin/highlight/highlight.js"></script>
                <script src="../plugin/notes/notes.js"></script>
                <script src="../plugin/search/search.js"></script>
                <script src="../plugin/math/math.js"></script>
                <script>
                  Reveal.initialize({
                    hash: true,
                    // Learn about plugins: https://revealjs.com/plugins/
                    plugins: [ RevealMarkdown, RevealHighlight, RevealNotes, RevealSearch, RevealMath ]
                  });
                </script>
              </body>
            </html>
      ingress:
        enabled: false
        annotations: {}
        hosts:
          - host: revealjs.example.com
            paths: ["/"]
        tls: []
destination:
  server: 'https://kubernetes.default.svc'
  namespace: revealjs
syncPolicy:
  automated:
    allowEmpty: true
  syncOptions:
    - CreateNamespace=true
```
</details>

## Used tools
This is a list of used software

| Tool | Version | Reason |
| ------ | ------ |------ |
| Revealjs   | 5.0.4 | Main shipped software |
| Nginx (offical image) | nginx:alpine3.18 | Webserver |
| Kaniko (Image build) | -| Container builder |


## Local testing with image
The Contaienr image are located at ghcr.
With this example command, you can pull the image to you local env:
```
nerdctl run ghcr.io/syntax3rror404/revealjs-helm:master
```
<div align="center">
  MIT licence | Copyright © 2024 Marcel Zapf
</div>
