---
# Title of your post. If not set, filename will be used.
title: "PKCS12 인증서를 Java keystore에 넣기."
date: 2011-02-21T14:11:00+09:00
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

PKCS12 인증서를 Java keystore에 넣기.

JDK1.5까지는 제공되지 않았던 기능으로 보이는데, JDK1.6에서는 keytool 명령으로 pkcs12인증서(*.p12)를 java keystore에 넣는 것이 가능하도록 바뀌었습니다.

```bash
keytool \
-importkeystore \
-srckeystore cert.p12 \
-destkeystore keystore.jks \
-srcstoretype pkcs12 \
-deststoretype jks \
-srcalias mycert \
-destalias mycert
```
