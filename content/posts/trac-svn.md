---
# Title of your post. If not set, filename will be used.
title: "Trac + SVN 을 사용하여 협업하기"
date: 2010-06-12T14:22:00+09:00
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

개발업무를 하면, 당연히 소스코드를 관리할 필요가 있습니다.
그래서 일반적으로 CVS SVN GIT ... 등의 소스 버전 관리툴을 사용합니다.
하지만 잘못 사용하고 계신 사용자 분도 계십니다. ( ex. 커밋시점 등. 테스트가 완료되지 않은 코드를 커밋하여 테스트. )

저는 trac 이란 툴과 SVN을 사용하여 협업을 하고 있습니다.

SVN에서 소스코드를 관리해 주고, Trac을 통해 타임라인 확인(히스토리), wiki 기능을 통한 문서 및 지침사항 정리, ticket을 통한 이슈 사항 관리를 하고 있습니다.

저는 현재 trac의 레포지토리 관리를 제 업무특성상, 고객사별로 레포지토리를 만들어 사용중입니다. 차후 버전에서는 멀티레포지토리를 지원한다고 하는데, 정확하게 어떻게 되는지는 모릅니다.

리눅스 서버를 하나가지고 계시면, 이번에 Trac + SVN 의 협업 개발환경을 사용해 보시는 것은 어떨까 권해드립니다.

trac 홈페이지 : <a href="http://trac.edgewall.org/">http://trac.edgewall.org/</a>

저는 현재, 소스코드 뿐 아닌 노출하지 말아야할 정보도 trac으로 관리하다 보니 인터넷에는 공개를 못하고, 사내에서만 사용합니다.
