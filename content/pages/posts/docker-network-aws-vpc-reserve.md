---
# Title of your post. If not set, filename will be used.
title: "Reserve Docker Network Aws Vpc uses"
date: 2022-09-09T09:57:35+09:00
draft: true

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "AWS"
  - "Docker"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

## Script

- docker_aws_vpc.sh
  ```bash
  #!/bin/bash

  # to prevent docker to pickup 172.31.0.0/16
  docker network \
  create \
  --subnet 172.31.253.0/30 \
  aws_vpc
  ```

## Description

While you are developing, it is convinient if you are using VPN to access AWS VPC.

But, some times you may experience some of container cannot access AWS Resources.

In that case, the container might be being assigned `docker network` that is overwrapping with AWS VPC network.

To prevent this to happen, you can create `docker network` that is same as AWS VPC to not to be used as container network.

## 설명

로컬 개발환경을 사용하면서, AWS VPC를 VPN으로 연결해서 사용하던가 하면, VPC안에 생성한 네트워크를 바로 접근할 수 있어서, 편리합니다.

하지만, docker 개발환경을 계속 사용하다보면, 어떤 컨테이너가 생성되었는데, 해당 컨테이너에서 AWS Resource를 사용하지 못하는 경우가 발생합니다.

그 경우, 해당 컨테이너가 docker network를 할당 받을 때, AWS VPC에서 사용하는 네트워크에 겹치는 경우가 생길 수 있습니다.

이런 경우를 사전에 방지하고자, docker network에 미리 AWS VPC에서 사용하는 대역을 잡아 두게 되면, 다른 컨테이너가 생길 때, 해당 네트워크를 사용하지 않도록 방지할 수 있습니다.
