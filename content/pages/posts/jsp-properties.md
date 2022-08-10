---
# Title of your post. If not set, filename will be used.
title: "Java properties 에서 문자 치환하기."
date: 2010-06-17T16:25:00+09:00
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

저는 아래와 같은 properties 파일을 만들고, 
```properties
UNKNOWNERROR=알 수 없는 오류입니다.(ERRORCODE)
```

아래와 같은 코드로 <strong>ERRORCODE</strong>를 대체해 왔습니다.

```java
package com.idatabank.sso.exception;

import java.util.ResourceBundle;

public class SSOException extends Exception {
    public SSOException() {
        super();
    }
    
    public SSOException(String errorType) {
        super(errorType);
        
        userMessage = rb.getString(errorType);
        
        if ( userMessage == null ) {
            userMessage = rb.getString("UNKNOWNERROR").replaceAll("ERRORCODE", errorType);
        }
    }
    
    /**
     * 사용자 에러 메시지를 세팅한다.
     * @param userMessage
     */
    public void setUserMessage(String userMessage) {
        this.userMessage = userMessage;
    }
    
    /**
     * 사용자 에러 메시지를 반환한다.
     * @return
     */
    public String getUserMessage() {
        return userMessage;
    }
    
    private String userMessage = null;
    private static final ResourceBundle rb = ResourceBundle.getBundle("com.idatabank.sso.exception.Messages");
}
```

그런데, 오늘 문자열 치환의 새로운 방법을 찾았습니다.
```
http.method_not_implemented=Method {0} is not defined in RFC 2068 and is not supported by the Servlet API 
```

```java
      String errMsg = rb.getString("http.method_not_implemented");
      Object[] errArgs = new Object[1];
      errArgs[0] = method;
      errMsg = java.text.MessageFormat.format(errMsg, errArgs);
```
이 방법이 좀더 우아해 보입니다.
