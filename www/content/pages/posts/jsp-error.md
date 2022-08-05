---
# Title of your post. If not set, filename will be used.
title: "JSP 에러 페이지"
date: 2010-06-11T13:29:00+09:00
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

JSP 페이지에서 errorPage 로 사용할 수 있는 페이지입니다.

```jsp
<%@ page contentType="text/html;charset=EUC-KR" isErrorPage="true"
    import="java.io.CharArrayWriter, java.io.PrintWriter"%>
<%
if (exception != null) {
  out.println(exception.getMessage());
  CharArrayWriter charArrayWriter = new CharArrayWriter();
  PrintWriter printWriter = new PrintWriter(charArrayWriter, true);
  exception.printStackTrace(printWriter);
  out.println(charArrayWriter.toString());
}
%>
```

Oracle JDeveloper 10g 에서 기본으로 제공하는 페이지 샘플을 가져옴.
