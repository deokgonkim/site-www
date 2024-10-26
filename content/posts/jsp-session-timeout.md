---
# Title of your post. If not set, filename will be used.
title: "Java 웹 세션타임아웃 설정?"
date: 2010-06-08T11:15:00+09:00
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

자바 웹애플리케이션에서 세션타임아웃은 web.xml 에서 정의합니다.

```xml
<web-app>
    <session-config>
        <session-timeout>35</session-timeout>
    </session-config>
</web-app>
```

단위는 분(minute)입니다.
