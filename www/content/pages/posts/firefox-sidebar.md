---
# Title of your post. If not set, filename will be used.
title: "firefox sidebar를 준비해보다..."
date: 2017-07-01T19:56:00+09:00
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

아래 삽질 기록이 좀 있습니다만.

우선, 기본적인 클라이언트측 컨셉은 가능하겠다는 판단까지 왔습니다.

우선, webextension 예제에서 2가지를 테스트하였고, 조합하면 동작할 것 같습니다.

https://github.com/mdn/webextensions-examples/tree/master/annotate-page
위 예제를 통해서, sidebar를 띄우는 방법이 나왔습니다.
단, sidebar 내용이 서버측 내용이 아닌 로컬 내용인데, 로컬에서 커버할지 웹을 띄울지 고민이 필요한 것 같습니다.

https://github.com/mdn/webextensions-examples/tree/master/bookmark-it
bookmark에 바로 접근하는 것이 가능한 것으로 나오는데,
이걸 활용하고, 로컬 북마크와 서버측 북마크를 연동할 것인지는 고민이 필요합니다.

annotate-page는 sidebar에 뭔가 표시가 가능하다는 것을 의미하며,
bookmark-it은 currentTab.url에 접근 가능하고, XHR 요청이 가능하다는? 것이 테스트되었습니다.

이제 이걸 쓸만하도록 클라이언트 앱을 만드는 것이 필요한데, ...
먼저 해결해야할 산이 남은 것이 아래 적은 것과 같이. codeigniter restful 서버 만드는 것, 그 전에 인증 문제 해결하는 것 등이 남았네요. 웹에 표현하는 tag cloud 같은 건 논외로 하더라도, ...

어쨌든, firefox extension 완성되면, codeigniter 버전도 만들어 보고, django 버전도 만들어 보면 좋겠다는 계획입니다. ... 이 계획이 언제 실현되어 제품으로 나올지는 모르겠지만 ... spring에서는 restful API나, spring-security가 경험이 있어 model만 만들면 바로 동작하는 것은 만들 수 있겠다고 생각하지만,, .... 무엇보다 큰 문제는, 사용자 웹 인터페이스가 ...

<hr />

예전에는 SiteBar라는 프로그램을 사용하여 북마크를 관리?했었습니다.

그러던 중, SiteBar가 PHP7과 호환성 문제가 있어 사용하지 못하게 되었습니다.

그래서 이번에는 한번 만들어 볼까? 고민하고 있었지요.

간편한 시작을 위해서 웹서버쪽을 PHP + CodeIgniter사용하고,
클라이언트는 Firefox Sidebar를 사용해 보고자 했습니다.

...

Firefox Sidebar를 만드는 방법이 역사가 있고, 바뀌어 가기도 하는데, 그중 최신인,
web extension을 사용해서 틀을 잡아보기로 하였습니다.

https://github.com/mdn/webextensions-examples/

그런데, ...

XHR을 통해서 링크를 서버로 보내는 것을 준비하다가, ...

심각한 상황에 빠졌느데, ... CI에서 log_message 걸다보니, httpd가 hang 걸리고, ...

그러다가, gdb, lsof, debuginfo-install httpd-2.4.6-45.el7.centos.x86_64
하는 상황까지 오게된. ...

...

그나 저나, 해야 할 일들은 아래와 같이 시작도 못했는데, ...

1. firefox web extension 사용하여 sidebar 활용 등의 클라이언트 프로그램 준비
2. 서버측 bookmark 모델 설계
3. 서버측 codeigniter LDAP 및 인증 모듈 개발
4. 서버측 codeigniter bookmark RESTful 인터페이스 개발
5. 서버측 codeigniter web 인터페이스 개발 ( bootstrap 사용할까? )

참조 URL
https://developer.mozilla.org/en-US/docs/Mozilla/Creating_a_Firefox_sidebar
https://github.com/kyoshino/simple-sidebar
https://developer.mozilla.org/en-US/Add-ons/WebExtensions
https://developer.mozilla.org/en-US/Add-ons/WebExtensions/user_interface/Sidebars
https://github.com/mdn/webextensions-examples/

ps. 헐, 위에 적은 debuginfo-install은 시작이었고, 아래와 같은 엄청난 메시지가 나오는데, 포기할까 싶은 생각이 바로 ...
debuginfo-install bzip2-libs-1.0.6-13.el7.x86_64 cyrus-sasl-lib-2.1.26-20.el7_2.x86_64 elfutils-libelf-0.166-2.el7.x86_64 elfutils-libs-0.166-2.el7.x86_64 file-libs-5.11-33.el7.x86_64 freetype-2.4.11-12.el7.x86_64 gmp-6.0.0-12.el7_1.x86_64 keyutils-libs-1.5.8-3.el7.x86_64 krb5-libs-1.14.1-27.el7_3.x86_64 libX11-1.6.3-3.el7.x86_64 libXau-1.0.8-2.1.el7.x86_64 libXpm-3.5.11-3.el7.x86_64 libattr-2.4.46-12.el7.x86_64 libcap-2.22-8.el7.x86_64 libcom_err-1.42.9-9.el7.x86_64 libcurl-7.29.0-35.el7.centos.x86_64 libgcc-4.8.5-11.el7.x86_64 libgcrypt-1.5.3-13.el7_3.1.x86_64 libgpg-error-1.12-3.el7.x86_64 libidn-1.28-4.el7.x86_64 libjpeg-turbo-1.2.90-5.el7.x86_64 libpng-1.5.13-7.el7_2.x86_64 libssh2-1.4.3-10.el7_2.1.x86_64 libstdc++-4.8.5-11.el7.x86_64 libuuid-2.23.2-33.el7.x86_64 libxcb-1.11-4.el7.x86_64 libxml2-2.9.1-6.el7_2.3.x86_64 libxslt-1.1.28-5.el7.x86_64 libzip-0.10.1-8.el7.x86_64 mariadb-libs-5.5.52-1.el7.x86_64 mod_dav_svn-1.7.14-10.el7.x86_64 mod_wsgi-3.4-12.el7_0.x86_64 nspr-4.11.0-1.el7_2.x86_64 nss-3.21.3-2.el7_3.x86_64 nss-softokn-freebl-3.16.2.3-14.4.el7.x86_64 nss-util-3.21.3-1.1.el7_3.x86_64 openldap-2.4.40-13.el7.x86_64 openssl-libs-1.0.1e-60.el7.x86_64 php-5.4.16-42.el7.x86_64 php-common-5.4.16-42.el7.x86_64 php-gd-5.4.16-42.el7.x86_64 php-ldap-5.4.16-42.el7.x86_64 php-mbstring-5.4.16-42.el7.x86_64 php-mysql-5.4.16-42.el7.x86_64 php-pdo-5.4.16-42.el7.x86_64 php-process-5.4.16-42.el7.x86_64 php-xml-5.4.16-42.el7.x86_64 python-libs-2.7.5-48.el7.x86_64 sqlite-3.7.17-8.el7.x86_64 subversion-libs-1.7.14-10.el7.x86_64 t1lib-5.1.2-14.el7.x86_64 xz-libs-5.2.2-1.el7.x86_64
지금 서버가 테스트 개발 서버라면 몰라도, 준 운용 서버인데, 위와 같은 짓을 하기는 싫은데, ...

ps. 환장할 일일쎼... Java는 보통 hang상황에서 thread dump라는 편리한 도구를 사용했었고, apache는 server-status 활용하고, tcpdump나 lsof 등으로 대충 찍으면, 뭔짓을 하는지 나왔었는데, ... 지금 버그인지, 뭔지는, gdb로 찾아야 하다니 하면서, ...

ps. 정확한 원인은 모르겠으나, 우선 보이는 것부터 잡아보려고, ...

```
#9  0x00007f01cba6a344 in php_verror (docref=<optimized out>, params=params@entry=0x7f01cbb81ce5 "", type=type@entry=2, 
    format=format@entry=0x7f01cbb7bb08 "It is not safe to rely on the system's timezone settings. You are *required* to use the date.timezone setting or the date_default_timezone_set() function. In case you used any of those methods and you"..., 
    args=args@entry=0x7fff62819750) at /usr/src/debug/php-5.4.16/main/main.c:862
```