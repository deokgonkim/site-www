---
# Title of your post. If not set, filename will be used.
title: "OpenVPN으로 가상사설망 구축하기"
date: 2010-06-19T16:31:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Open Source"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

OpenVPN으로 가상 사설망 구축이 가능합니다.

<a href="http://openvpn.net/">http://openvpn.net/</a>

### 1. OpenVPN 서버 설치

```bash
$ sudo apt-get install openvpn
```

openvpn용 dh파일 만들기

```bash
$ openssl dhparam -out dh1024.pem 1024
```

openvpn 서버용 설정파일 만들기

```
port 1194
proto udp
dev tun0

ca ca.crt
cert server.crt
key server.key

dh dh1024.pem

server 10.8.0.0 255.255.255.0

ifconfig-pool-persist ipp.txt

push "route 168.126.63.1 255.255.255.255"
push "route 168.126.63.2 255.255.255.255"

client-to-client

keepalive 10 120

comp-lzo

persist-key
persist-tun

status openvpn-status.log

verb 3
```

위 구성은 아래 내용으로 요약합니다.

  - 클라이언트가 접속할 포트는 udp 1194 입니다.
  - 10.8.0.0/24 를 클라이언트에게 할당할 IP 풀로 사용합니다.
  - 클라이언트가 168.126.63.1, 168.126.63.2 로 접근할 때, VPN 접속을 사용하도록 합니다.
  - 클라이언트간 통신이 가능합니다.

서버에서는 매스커레이딩 혹은 라우팅 설정이 있어야 정상적으로 사용할 수 있습니다. ( 10.8.0.0/24의 사설 IP풀을 사용하므로 )

### 2. 클라이언트 사용하기

아래 URL에서 클라이언트 프로그램을 받을 수 있습니다. 윈도우에서 사용하는 GUI인터페이스를 제공하는 클라이언트입니다.

<a href="http://openvpn.se/">http://openvpn.se/</a>

설치후, 클라이언트용 설정을 아래와 같이 생성합니다.

```
client
dev tun
proto udp

remote vpn-server.dgkim.net 1194

nobind

persist-key
persist-tun

ca cacert.pem
cert dgkimcert.pem
key dgkimkey.pem

verb 3
comp-lzo
```