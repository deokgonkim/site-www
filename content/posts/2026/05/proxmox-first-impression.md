---
# Title of your post. If not set, filename will be used.
title: "Proxmox First Impression"
date: 2026-05-24T12:00:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 100

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - proxmox
---

## Proxmox VE First Impression

- proxmox 어제 첫 설치 및 사용경험 기준.

- ubuntu desktop 깔고, virt-manager 사용하는 것보단, 가볍긴 하겠다.  
  (ubuntu는 aws vm에서 말고는 headless(?)로 깔아본 기억이 거의 없다. gui로만 깔지, text server로 깔아본적도 거의 없어서)
- nat network가 기본이 아니고, bridge가 기본인게, 실험하기 더편리하긴 하겠지?  
  (bridge가 더 편하긴 한데, 리눅스 랩탑의 wifi로는 bridge가 잘 안 되는 것 같아 좀 불편하긴 했었다.)  
  (그리고, proxmox설치한 기기에는 wifi말고 유선랜을 붙여주었다)
- lxc 컨테이너를 bridge에 바로 만들어주니까, 네트워크가 되는 lxc container를 처음으로 경험해 보았다.  
  (리눅스 랩탑에서 nat 네트워크로 붙여지고, 로컬에서는 lxc exec bash 형태로만 사용해 왔다.)

- 하이퍼바이저라고만 알았지, ubuntu/debian 기반인줄은 몰랐다. (thankyou 하고)

- aws ami / openstack 같이 편할 줄 기대했는데, 그정도까지는 아니네.
