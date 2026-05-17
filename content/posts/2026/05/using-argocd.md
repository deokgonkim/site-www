---
# Title of your post. If not set, filename will be used.
title: "Using Argocd"
date: 2026-05-17T14:00:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - development
  - kubernetes
---

## Steps

- Create K3s cluster : *not documented yet*
- [Install `kubectl` on local linux](#install-kubectl)
- [Configure local linux environment to use K3s](#configure-kubectl-to-k3s)
- [Install `argocd` on k3s cluster](#install-argocd-on-k3s-cluster)
- [Prepare the first `gitops` project](#prepare-first-gitops-project)
  - [create `gitops` git repository](#create-gitops-git-repository)
  - [deploy first `gitops` project](#deploy-first-gitops-project)
  - [create first `app` git repository](#create-first-app-git-repository)
  - [add `app` to `gitops` project](#add-app-to-gitops-project)
- [Further to know](#further-to-know)

## Install kubectl

`kubectl` can be installed as a single binary. So, user can install in `~/bin` directory

```shell
cd Downloads
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.3/2026-04-08/bin/darwin/amd64/kubectl
cp kubectl ~/bin/
chmod +x ~/bin/kubectl
kubectl version
```

## Configure kubectl to k3s

Copy the configuration from k3s to local kube config

```shell
mkdir -p ~/.kube
scp user@K3S_SERVER_IP:/etc/rancher/k3s/k3s.yaml ~/.kube/k3s.yaml
# update server ip address in k3s.yaml from 127.0.0.1 to k3s server ip
KUBECONFIG=~/.kube/config:~/.kube/k3s.yaml kubectl config view --flatten > /tmp/config
mv /tmp/config ~/.kube/config
```

Check some `kubectl` commands

```shell
kubectl version
kubectl config get-contexts
kubectl get pods -A
```

## Install `argocd` on k3s cluster

Following command will create `argocd` kube namespace and install the `argocd` server

```shell
kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

`argocd` CLI can be installed as a single binary(like `kubectl` command)

```shell
cd ~/Downloads
wget https://github.com/argoproj/argo-cd/releases/download/v3.4.2/argocd-linux-amd64
cp argocd-linux-amd64 ~/bin/argocd
chmod +x ~/bin/argocd
```

Accessing `argocd` Web GUI for the first time. (without configuring front-facing web server, just access via http://localhost:8080)

```shell
# will open localhost:8080 pointing to argocd:443
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

The default passsword for `admin` user is not statically defined. It is auto-generated password and should be obtained via command

```
argocd admin initial-password -n argocd
```

## Prepare first `gitops` project

### Create `gitops` git repository

The `gitops` project is not a actual application project. It defines `deployment` of the application.

- My first gitops project structure [kube-hello-gitops](https://github.com/dgkim-lab/kube-hello-gitops)

Summarized structure of the repository:

```text
kube-hello-gitops/
|-- argocd/
|   `-- root-application.yaml        # bootstrap Argo CD root application
|-- apps/
|   `-- dev/
|       |-- hello-app.yaml           # child Argo CD application
|-- workloads/
|   |-- hello-app/
|   |   |-- base/                    # shared Kubernetes manifests
|   |   |   |-- deployment.yaml
|   |   |   |-- kustomization.yaml
|   |   |   `-- service.yaml
|   |   `-- overlays/
|   |       `-- dev/
|   |           `-- kustomization.yaml
`-- scripts/                         # local helper scripts
```

### Deploy first `gitops` project

The created `gitops` project need to be installed on `argocd`
I thought if I register `git` repository in `ArgoCD > Settings > Repo`. It didn't automatically run `deployments`

It can be done via `argocd` cli to register application
or
Invoke `kubectl` to run the first `deployment`

I chosen to use `kubectl` for the first step.

```shell
kubectl apply -f argocd/root-application.yaml
```

After successful deployment check `argocd` web UI that application is appeared.
The simple app doesn't expose web url by default. Here I use port forwarding again to check the app is running.

```shell
exec kubectl -n hello-dev port-forward "svc/hello-app" "8081:80"
# user can access `hello-app` via http://localhost:8081
```

### Create first `app` git repository

To deploy an actual application project via `argocd`
I created separate app git repository [kube-hello-app](https://github.com/dgkim-lab/kube-hello-app)

This project is a simple dockerized express app.

This project is built on github actions. and publish docker image to github packages.

```yaml
name: Publish Docker Image

on:
  push:
    branches:
      - master
  workflow_dispatch:

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: dgkim-lab/kube-hello-app

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract Docker metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=raw,value=latest
            type=sha

      - name: Build and push Docker image
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

### Add `app` to `gitops` project

In order for `argocd` to fetch `private` `image` from `GHCR`, the practical way to allow this is register `credential` element inside kubenetes.  
(to store a secret in `git` repository is a bad idea.)  
(*I haven't tested AWS Secrets Manger yet*)

```shell
kubectl -n "${NAMESPACE}" create secret docker-registry "${SECRET_NAME}" \
  --docker-server="${DOCKER_SERVER}" \
  --docker-username="${GITHUB_USERNAME}" \
  --docker-password="${GITHUB_TOKEN}" \
  --dry-run=client -o yaml | kubectl apply -f -
```

Updated `gitops` git repository structure:

```text
kube-hello-gitops/
|-- argocd/
|   `-- root-application.yaml        # bootstrap Argo CD root application
|-- apps/
|   `-- dev/
|       |-- hello-app.yaml           # child Argo CD application
|       `-- kube-hello-app.yaml      # child Argo CD application
|-- workloads/
|   |-- hello-app/
|   |   |-- base/                    # shared Kubernetes manifests
|   |   |   |-- deployment.yaml
|   |   |   |-- kustomization.yaml
|   |   |   `-- service.yaml
|   |   `-- overlays/
|   |       `-- dev/
|   |           `-- kustomization.yaml
|   `-- kube-hello-app/
|       |-- base/                    # shared manifests for GHCR-backed app
|       |   |-- deployment.yaml
|       |   |-- kustomization.yaml
|       |   |-- service.yaml
|       |   `-- serviceaccount.yaml
|       `-- overlays/
|           `-- dev/                 # environment-specific customization
|               `-- kustomization.yaml
`-- scripts/                         # local helper scripts
```

And when the commit is pushed to github, then after a short delay the new application is deployed.

## Further to know.

Here are what I haven't tested yet.

- What is `kustomize`?
- How to attach external accessible url?
- Test docker image `tag` for publish and deploy new version via argocd

## References

- https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
- https://argo-cd.readthedocs.io/en/stable/getting_started/
- https://argo-cd.readthedocs.io/en/stable/cli_installation/
- https://argo-cd.readthedocs.io/en/stable/understand_the_basics/
- https://www.freecodecamp.org/news/a-beginner-friendly-introduction-to-containers-vms-and-docker-79a9e3e119b
- https://www.edx.org/learn/kubernetes/the-linux-foundation-introduction-to-kubernetes
