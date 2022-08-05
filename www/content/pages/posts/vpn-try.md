---
# Title of your post. If not set, filename will be used.
title: "VPN 연동 시도 노트"
date: 2010-07-16T15:58:00+09:00
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

리눅스에서 VPN 서버를 구축해 볼까 시도했습니다.

처음에는 PPTP 방식으로 시도를 했습니다. <a href="http://www.poptop.org/">Poptop</a>으로 시도를 했습니다. 연결은 정상적으로 하였으나, 인증정보를 LDAP으로 하려 했는데, 윈도우에서 Samba를 기준으로 쿼리를 하였고, Samba에 LDAP연동을 시도했으나, 기존의 LDAP에 Samba가 준비되지 않아 실패하였습니다.

다음으로 IPSEC을 시도했습니다. 윈도우의 경우 IPSEC만으로 VPN이 되지 않고, L2TP도 세팅해야 하는데, 마땅한 자료 및 구현이 없어 포기했습니다.

IPSEC은 마지막으로 IPHONE의 IPSEC으로 세팅해보고자 시도를 했습니다. Racoon 이란 것으로 시도를 했고, 접속간 키교환에 인증서를 사용하는 것 까지는 성공했습니다.

하지만, Ubuntu에서 제공하는 Racoon은 LDAP이나 RADIUS와 빌드되지 않아 인증을 수행하지 못해서 최종적으로 실패하였습니다.


이번 작업에서 IPSEC에 대해 좀 더 알게 되었고, RADIUS 서버를 구축하였습니다. ( RADIUS는 현재 활용할 클라이언트가 아직 없네요. )


IPSEC 관련 정보
<a href="http://www.ipsec-howto.org/ipsec-howto.pdf">http://www.ipsec-howto.org/ipsec-howto.pdf</a>
<a href="http://lartc.org/lartc.pdf">http://lartc.org/lartc.pdf</a>
