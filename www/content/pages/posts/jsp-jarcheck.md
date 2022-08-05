---
# Title of your post. If not set, filename will be used.
title: "Java jarcheck.jsp로 클래스 파일 찾기"
date: 2010-06-11T15:11:00+09:00
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

Java 웹애플리케이션에서 클래스 파일의 실제 위치를 찾을 때 사용하는 유용한 jsp
<!-- <a href='http://www.dgkim.net/wordpress/archives/79/jarcheck-jsp' rel='attachment wp-att-93'>jarcheck.jsp</a> -->

```java
    String reqName = null;
    java.net.URL classUrl = null;
    reqName = request.getParameter("reqName");
    if (reqName == null || reqName.trim().length() == 0) {
        reqName = "javax.servlet.http.HttpServlet";
    }
    if (reqName.trim().length() != 0) {
 	reqName = reqName.replace('.', '/').trim();
	reqName = "/" + reqName + ".class";
        classUrl = this.getClass().getResource(reqName);
        if (classUrl == null) {
            out.println(reqName + " not found");
        } else {
            out.println("<b>" + reqName + "</b>: [" + classUrl.getFile() + "]\n" );
        }
        out.println("<br>");
    }
```

소스의 출처/원본은 javaservice.net 입니다.