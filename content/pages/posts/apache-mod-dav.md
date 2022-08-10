---
# Title of your post. If not set, filename will be used.
title: "Apache DAV를 사용하여 웹폴더 활용"
date: 2010-06-06T17:09:00+09:00
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

아파치에서 제공되는 mod_dav 모듈을 사용하여 웹폴더를 사용할 수 있습니다.

http://httpd.apache.org/docs/2.2/mod/mod_dav.html

간단한 웹폴더 설정 예제

```
Alias /dav "/home/www/dav"
<Location /dav>
    Dav On
    <LimitExcept GET OPTIONS>
        Order deny,allow
        Deny from all
        Allow from 10.8.0.0/255.255.255.0
    </LimitExcept>
<Location>
```

**/dav** 경로를 웹폴더로 지정하였으며, IP주소가 **10.8.0.0/24**인 사용자만 사용할 수 있도록 제한한 예입니다.(저는 VPN접속으로 사용하고 있습니다.)

dav 모듈을 켠 상태에서 `location` 설정 등에 `Dav On` 이란 설정으로 웹폴더 기능이 활성화됩니다.

추가로, LDAP으로 로그인 모듈을 사용할 수도 있습니다. ( 다음 기회에 )