---
# Title of your post. If not set, filename will be used.
title: "Hacked 2014"
date: 2014-05-18T15:41:00+09:00
draft: true

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

어제 제 서버에 원치 않는 접속이 발견되었습니다.

나름 denyhosts, fail2ban을 통해서 안전하게 지켜보려고 했습니다만.

어떤 경로를 통했는지 알 수 없으나, ssh로 접속 3번 성공하였고,

history를 제거하여 뭘했는지 알 수 없도록 조치까지 해두었습니다.

나쁜 의도를 가진 해커라면 어쩔 수 없지만,

그렇게 나쁜 해커가 아니라면, 어떤 방법으로 침입하였는지 알고 싶습니다.

나름 chkrootkit도 돌려봤지만, 어떤 나쁜 것이 있을지 불안하네요.
