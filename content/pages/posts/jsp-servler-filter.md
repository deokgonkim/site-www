---
# Title of your post. If not set, filename will be used.
title: "Java 서블릿 필터 활용하기"
date: 2010-06-14T17:29:00+09:00
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

Java 웹애플리케이션에서는 servlet filter라는 기능이 있습니다.

저는 주로, servlet filter를 통해 권한 체크를 수행합니다.

servlet filter의 경우 servlet 이나 jsp 등이 수행되기 전에 사전 처리를 하거나, 처리후 사후 처리를 하는데 활용할 수 있습니다.

servlet filter는 web.xml에서 정의합니다.
```xml
   <filter>
        <filter-name>AuthFilter</filter-name>
        <filter-class>test.AuthFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>AuthFilter</filter-name>
        <url-pattern>/*.do</url-pattern>
    </filter-mapping>
```

위 필터의 경우 <strong>test.AuthFilter</strong> 클래스를 필터로 등록했으며,
<strong>/*.do</strong> URL에 대한 접근에 대해서 필터 처리를 수행합니다.

서블릿 필터의 구현은 아래와 같이 정의합니다.
```java
package test;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AuthFilter implements Filter {
    private FilterConfig _filterConfig = null;

    public void init(FilterConfig filterConfig) throws ServletException {
        _filterConfig = filterConfig;
    }

    public void destroy() {
        _filterConfig = null;
    }

    public void doFilter(ServletRequest request, ServletResponse response, 
                         FilterChain chain) throws IOException, ServletException {
        // 사전권한 체크 수행
        chain.doFilter(request, response);
        // 사후 처리 수행
    }
}
```

위와 같이 <strong>javax.servlet.Filter</strong> 인터페이스를 구현하여 정의합니다.

doFilter 에서 <strong>사전권한 체크 수행</strong> 부분에서 서블릿 수행전에 수행할 작업들을 정의할 수 있습니다.

그리고, 만약 여러개의 필터가 사용되고 있다면(filter는 여러개를 사용할 수 있습니다.) <strong>chain.doFilter</strong>에서 다음으로 정의된 filter의 doFilter를 수행합니다.
그리고, 마지막으로 서블릿 컨테이너가 다른 filter가 없을 경우 서블릿으로 처리를 넘기게 됩니다.

그리고, <strong>chain.doFilter</strong> 이후에, 추가적으로 처리할 작업이 있으면 <strong>사후 처리 수행</strong> 부분에서 처리할 수 있습니다.


그리고, 현재 가장 많이 사용되는 것이 characterset filter입니다.

java에서는 encoding의 변환이 발생하는 경우가 많습니다. ( ex. os charset과 웹 charset이 다른 경우 주로 getBytes를 통한 문자 변환을 사용 )

아래는 스프링프레임워크에서 자체 제공하는 servlet filter의 사용 예입니다.
```xml
    <filter>
        <filter-name>encodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>EUC-KR</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>encodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
```

필터도 역시 목적에 따라 잘 활용할 경우 유용하게 활용할 수 있습니다.
