---
# Title of your post. If not set, filename will be used.
title: "tomcat parallel deployment"
date: 2014-08-04T13:57:00+09:00
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

톰캣이 이미 8.0까지 나온 시점에 인터넷에서 흥미를 끄는 내용을 하나 접했습니다.

http://www.youtube.com/watch?v=Bp789a8MBWI

parallel deployment라는 제목에서는

전략을 얘기하는 것인 줄 알았는데, 기능이었습니다.

tomcat 7.0 부터 지원하는 기능으로 무중단 배포를 할 수 있는 기능입니다.

즉, app v1 운용중에 app v2를 배포할 수 있고,
기존 세션 사용자는 v1을 사용하고 신규 접속자는 v2로 접근하게 됩니다.

저는 weblogic에서 production redeployment로 접했던 기능입니다.

상세내용은 위 링크에서 참조하십시오.
