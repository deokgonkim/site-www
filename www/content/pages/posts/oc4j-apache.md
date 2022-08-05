---
# Title of your post. If not set, filename will be used.
title: "Apache와 OC4J 연동하기."
date: 2010-06-25T15:27:00+09:00
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

Oracle Application Server는 크게 Oracle HTTP Server(Apache MOD)와 OC4J(Oracle Container for J2EE)로 구성되어 있습니다.

그런데, OC4J의 경우 단독으로도 사용할 수 있도록 Standalone 버전으로 Oracle에서 제공하고 있습니다.

만약, 서버를 저와 같이 PHP나 다른 Apache의 기능을 사용하고, OAS를 사용할 수 없는 환경에서 Apache와 OC4J를 연동하여 사용하는 방법을 알려드립니다.(물론 이미 알고 있는 분도 계시겠지만.)

먼저, Apache와 OC4J의 연동은 OAS 에서는 mod_oc4j 라는 모듈을 통해 처리합니다.
그러나, mod_oc4j는 OAS에 맞도록 작성되어 단독 Apache에 쓰기에는 무리가 있습니다.

다음으로, AJP를 통해 OC4J와 연동하는 것이 가능합니다.
그러나, 톰캣에서 제공하는 AJP 모듈과 OC4J모듈의 연동에서는 알 수 없는 문제가 발생했었습니다.

다음은, proxy 모듈을 사용하는 방법입니다.(이 방법을 소개합니다.)

저의 경우 Apache 2.2 버전에서 제공되는 proxy 모듈로 사용하고 있습니다.

```
LoadModule proxy_module /usr/lib/apache2/modules/mod_proxy.so
LoadModule proxy_http_module /usr/lib/apache2/modules/mod_proxy_http.so
```

위와 같이 모듈이 활성화 된 상태에서 아래와 같이 설정하여 OC4J와 연동이 가능합니다.

```
ProxyPass /ical2bi http://localhost:8888/ical2bi
```

위 설정은 Apache 웹서버에 <strong>/ical2bi</strong> 형태로 접근할 경우, OC4J의 <strong>/ical2bi</strong> 로 요청을 넘겨줍니다.

이 방법의 경우, 일반적으로 잘 돌아가지만, redirect 등과 같이 서버 주소를 참조하는 경우에는 정상 동작하지 않는 경우도 발생할 수 있습니다.

proxy 모듈을 통해서 저는 OC4J의 예제만 보여드렸습니다만, OC4J 뿐 아닌 다른 WAS나 심지어 다른 웹서버까지 요청을 전달할 수 있습니다.

저는 하나의 서버에 여러개의 애플리케이션을 돌리고, 각각 접근하는 URL에 따라 애플리케이션을 구분하여 서비스하고 있습니다.


ps. 제 서버에는 개발에 사용된 언어가 PHP, Python, Java, CGI(Perl) 입니다. 이중 Java부분을 OC4J로 처리하고 있습니다.
