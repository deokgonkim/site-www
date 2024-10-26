---
# Title of your post. If not set, filename will be used.
title: "weblogic nodemanager 명령 요약"
date: 2011-02-18T11:15:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "java"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

weblogic nodemanager 에 접속하여 명령을 하는 것에 대한 간단한 요약.

telnet 접속의 경우.
```
telnet wls.dgkim.net 5555
DOMAIN #도메인명#
USER weblogic
PASS #패스워드#
SERVER #서버#
KILL # 종료시.
START # 시작시.
```

ssl 접속의 경우.
```
openssl s_client -connect wls.dgkim.net:5556
DOMAIN #도메인명#
USER weblogic
PASS #패스워드#
SERVER #서버#
KILL # 종료시.
START # 시작시.
```
