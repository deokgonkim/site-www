---
# Title of your post. If not set, filename will be used.
title: "심심한데 챗봇 같은 걸 만들어 볼까?"
date: 2017-04-26T14:39:00+09:00
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

얼마전에 converse.js 사용해서 웹에다가 XMPP 채팅을 올렸었지요.
그리고, ... 많은 사람들이 블로그를 오긴 오던데, 말을 걸어주는이 없더만요.

어쨌든, 그걸 확장해 보고자 chatbot 챗봇을 한번 만들어 볼까 싶습니다.

요즘 python 연습하고 있으니 언어는 python, 맨땅에서 시작할 수 없으니,
google 검색에 'chatbot python xmpp' 넣고 검색을 합니다.

...

나왔습니다.
https://github.com/QuickBlox/sample-chatbot-python
이걸로 시작해 봅니다.

...
바로 시작이 안 됩니다. 의존성으로 sleekxmpp가 있습니다.
또 찾습니다.
https://github.com/fritzy/SleekXMPP/

...
잠시 환경을 준비해서 테스트를 시작하고, ...

...
아래 dnspython도 받아서 준비하고,
http://www.dnspython.org/kits/1.15.0/

...

ps. 테스트는 했습니다. 기본 기능이란 것이 로그인 및 MUC에 들어가 있다가, 멘션이 오면 반응하는 것이었는데, ... 그것 말고 ECHO 같이 말걸면 반응하는 것까지만 테스트해보았습니다. 이런 걸로 number guessing 게임 정도는 만들 수 있을 것 같은데, ... 혼자 노니 심심해서, 위 기록만 남겨두고, 그만 둡니다.
