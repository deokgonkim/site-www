---
# Title of your post. If not set, filename will be used.
title: "weblogic session persistence 설정하기"
date: 2011-09-05T16:23:00+09:00
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

웹로직에서 웹애플리케이션을 개발하고 배포를 하는 과정에서 재배포 혹은 서버 점검에 따라 인스턴스를 재기동할 경우 사용자 세션이 끊기는 현상이 발생합니다.

이에 대하여 웹로직 배치 기술자 조정을 통해 세션을 유지하는 방법을 찾아보고 글 남깁니다.

보통 세션 퍼시스턴스의 설정은 클러스터 환경에서 서로 다른 서버간 세션 공유에 활용되는 것이 많으리라 생각됩니다.

아래 설정은 단일 서버에서 파일에 세션 상태를 기록하여 세션을 유지하는 예제입니다.

```xml
<?xml version='1.0' encoding='UTF-8'?>
<weblogic-web-app xmlns="http://www.bea.com/ns/weblogic/90" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <session-descriptor>
    <persistent-store-type>file</persistent-store-type>
  </session-descriptor>

</weblogic-web-app>
```

세션에 사용자 정의 클래스를 넣을 경우, 해당 클래스를 serializable을 구현하도록 해야 합니다. 그렇지 않을 경우, 세션은 유지되나 해당 세션 애트리뷰트를 참조할 수 없습니다.

그리고 해당 출처는 아래와 같습니다.

http://download.oracle.com/docs/cd/E13222_01/wls/docs81/webapp/sessions.html
위 문서에 설명이 나오며, weblogic.xml 파일 실제 구조는 아래 URL에서 참조하였습니다.

http://cheese.springnote.com/pages/4542851
