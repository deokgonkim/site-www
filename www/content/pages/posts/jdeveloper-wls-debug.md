---
# Title of your post. If not set, filename will be used.
title: "JDeveloper + WebLogic 환경에서 Remote Debugging 사용하기."
date: 2011-05-17T15:03:00+09:00
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

JDeveloper와 WebLogic을 사용하는 개발환경에서 Integrated Server를 쓰지 않고, 테스트 혹은 운용서버에 배포후 Remote Debugging을 하는 방법을 간략히 소개합니다.

### 1. 대상 서버의 Remote Debugging JVM 옵션 세팅.
먼저 JVM에서 Remote Debugging을 받아들이기 위한 설정을 추가합니다.
아래 세팅을 서버의 구동 스크립트에 포함되도록 합니다.
( 저는 편의상 개발서버의 .profile을 사용하고 있습니다. nodemanager 등을 사용중인 경우에는 콘솔에서 세팅 가능하겠습니다. )

```bash
# JDK 1.4 이하 기본 형태
# -Xdebug -Xrunjdwp:transport=dt_socket,server=y,address=[port]
# JDK 1.5 이상 기본 형태
# -agentlib:jdwp=transport=dt_socket,server=y,address=[port]
JAVA_OPTIONS=$JAVA_OPTIONS\
"-Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=4000,server=y,suspend=n"
```

### 2. 대상 서버의 Tunneling 설정.

weblogic 콘솔에서 대상 서버의 Protocols탭에 Enable Tunneling.을 체크합니다.

### 3. JDeveloper에서 대상 프로젝트에 Remote Debugging 설정.

개발중인 프로젝트에 Remote Debugging을 세팅하는 과정입니다.


  - 'Project Properties'에서 'Run/Debug/Profile' 선택.
  - 'Run Configurations'에서 복제 혹은 기존 것을 편집.
  - 'Launch Settings'에서 'Remote Debugging' 체크.
  - 'Tool Settings' - 'Debugger' - 'Remote'에 아래 설정 추가.
      - Protocol : Attach to JPDA
      - Host : 해당서버 주소
      - Port : 4000 1항에서 설정.

### 4. Remote Debugging 시작.

프로젝트에서 'Start Remote Debugger'를 선택하면, 브레이크포인트 등 원하는 디버깅을 수행할 수 있습니다.
