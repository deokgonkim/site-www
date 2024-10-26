---
# Title of your post. If not set, filename will be used.
title: "시간동기화"
date: 2009-01-01T14:06:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "linux"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

## ntpdate를 사용한 설정
유닉스, 리눅스에서는 ntpdate라는 명령으로 시간을 특정서버(Time Server)의 시간과 동기화 할 수 있습니다.

문법은 아래와 같이 간단합니다.

```bash
ntpdate time.bora.net
```

단, ntpd 혹은 xntpd와 같은 데몬이 구동되어 있을 경우는 명령이 제대로 동작하지 않으며 데몬을 죽이고 명령을 내리면 됩니다.

Redhat 계열에서는 아래 명령으로 내릴 수 있으며, 일반적으로 /etc/init.d 디렉토리에 서비스 구동 명령이 포함되어 있습니다. 단, 아래 명령으로 내릴 경우, 시스템 재부팅시 서비스가 다시 구동되며, 문서를 참고하여 서비스를 영구 종료할 수 있습니다.

```bash
service ntpd stop
```

## ntp 데몬을 사용하는 설정

아래는 Unbuntu에서 사용중인 설정 내용입니다.

```
# /etc/ntp.conf, configuration for ntpd

driftfile /var/lib/ntp/ntp.drift
statsdir /var/log/ntpstats/

statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable

# You do need to talk to an NTP server or two (or three).
server ntp.ubuntu.com
server kr.pool.ntp.org
server 127.127.1.0
fudge 127.127.1.0 stratum 5

# By default, exchange time with everybody, but don't allow configuration.
# See /usr/share/doc/ntp-doc/html/accopt.html for details.
restrict default kod notrap nomodify nopeer noquery

# Local users may interrogate the ntp server more closely.
restrict 127.0.0.1 nomodify

# Clients from this (example!) subnet have unlimited access,
# but only if cryptographically authenticated
#restrict 192.168.123.0  mask  255.255.255.0 notrust

# If you want to provide time to your local subnet, change the next line.
# (Again, the address is an example only.)
#broadcast 192.168.123.255

# If you want to listen to time broadcasts on your local subnet,
# de-comment the next lines. Please do this only if you trust everybody
# on the network!
#disable auth
#broadcastclient
```
