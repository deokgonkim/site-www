---
# Title of your post. If not set, filename will be used.
title: "웹로직의 보편적인 웹개발상의 디버그"
date: 2011-06-17T16:47:00+09:00
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

웹로직을 사용하면서, 에러의 원인을 쉽게 찾을 수 없을 때, 원인을 추적하는 방법을 나열해 봅니다.

### dispatcher forward 사용시 해당 리소스가 없을 경우 추적하기.( 알 수 없는 404 에러 )

웹개발 프레임워크를 사용할 때 주로 개발하는 형태가, controller를 작성하여 비즈니스 로직을 수행한 후, 사용자에게 보여질 페이지(JSP)로 RequestDispatcher.forward 하는 형태이리라 생각됩니다. ( 물론 다른 형태도 많겠지만, RequestDispatcher.forward 하는 형태를 가정한 상황으로 글을 씁니다. )

아래는 그렇게 사용한 java servlet 예제입니다.

```java
RequestDispatcher rd = null;
rd = request.getRequestDispatcher("/main.jsp");
rd.forward(request, response);
```

이 경우 만약 main.jsp 파일이 존재하지 않는다면, 웹로직은 404 에러 페이지만 출력할 뿐입니다. 그러면 사용자는 호출한 URL이 존재하지 않는 것인지 forward 대상 페이지가 없는 것인지 알 수 없습니다.

tomcat 이나 다른 WAS의 경우는 주로 위 처리에 대한 에러가 로그파일 혹은 웹브라우저에 추적이 가능한 정보를 제공하는데, 웹로직은 404 에러코드만 줄 뿐 추가정보를 제공하지 않았습니다. ( 제 경험 )

이에 추적정보를 찾는 방법을 알았기에 공유합니다.

  - 해당 서버를 선택합니다.
  - 디버그 탭을 선택합니다.
  - weblogic 항목을 펼칩니다.
  - servlet 항목을 펼칩니다.
  - DebugURLResolution 항목에 체크표합니다.
  - 사용 버튼을 눌러 활성화 합니다.

위 과정을 거치면 아래와 같은 로그를 발견할 수 있습니다. 서버의 logs/서버명.log 파일에 기록됩니다.

```
####<2011. 6. 17 오후 4시 41분 10초 KST> <Debug> <URLResolution> <whity> <AdminServer> <[ACTIVE] ExecuteThread: '1' for queue: 'weblogic.kernel.Default (self-tuning)'> <<anonymous>> <> <> <1308296470912> <BEA-000000> <ServletContext@465470[app:test module:test path:/test spec-version:null]: resolving request with relUri: /main.jsp>
####<2011. 6. 17 오후 4시 41분 10초 KST> <Debug> <URLResolution> <whity> <AdminServer> <[ACTIVE] ExecuteThread: '1' for queue: 'weblogic.kernel.Default (self-tuning)'> <<anonymous>> <> <> <1308296470912> <BEA-000000> <ServletContext@465470[app:test module:test path:/test spec-version:null]: getResourceAsSource() couldn't find source for : /main.jsp>
```

위 로그 마지막 줄을 통해서 main.jsp 파일을 찾을 수 없다는 내용을 확인할 수 있습니다.
