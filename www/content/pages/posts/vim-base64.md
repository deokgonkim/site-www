---
# Title of your post. If not set, filename will be used.
title: "vim 간략 노트 base64 파일 다루기편"
date: 2013-01-21T16:30:00+09:00
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

메일에서 많이 사용되는 인코딩 방식으로 base64가 있습니다.

base64인코딩을 openssl과 같이 사용하면서 발생했던 문제에 대하여 vim을 통해 간단히 작업한 내용을 메모해 둡니다.

메일을 받아보면 아래와 같은 base64 인코딩 영역이 있습니다.

```
Content-Type: text/html; charset=euc-kr
Content-Transfer-Encoding: base64

PGh0bWw+DQo8aGVhZD4NCjxtZXRhIGh0dHAtZXF1aXY9IkNvbnRlbnQtVHlwZSIgY29udGVudD0i
dGV4dC9odG1sOyBjaGFyc2V0PWV1Yy1rciI+DQo8dGl0bGU+vsiz58fPvLy/5C4gvcXH0cSrteXA
1LTPtNkuPC90aXRsZT4NCjwvaGVhZD4NCiANCjxib2R5Pg0KPCEtLUhlYWRlciBTdGFydCAtLT4N
Cjx0YWJsZSB3aWR0aD0iNzAwIiBib3JkZXI9IjAiIGFsaWduPSJjZW50ZXIiIGNlbGxwYWRkaW5n
PSIwIiBjZWxsc3BhY2luZz0iMCIgc3R5bGU9ImJhY2tncm91bmQ6dXJsKGh0dHA6Ly9jYXJkaW1h
Z2Uuc2hpbmhhbmNhcmQuY29tL2ltZy9lbWFpbC9jb21tb24vMjAxMTExL2JnX0hlYWRlcl9iYXNp
```

위 내용은 줄바꿈문자를 있는 그대로 붙여 넣은 것입니다.

한 줄의 문자수가 77개 입니다. 위 내용의 경우는 openssl enc -d -a 명령을 통해 정상적으로 디코드하여 볼 수 있었습니다.

하지만, openssl에서 base64인코딩을 하면 보통, 한 줄이 64자리인 것을 많이 봅니다.

그래서, 이번에는 위와 같이 줄의 문자수가 맞지 않을 때, 줄을 맞추는 vim 명령을 해봤습니다.

```
# 내용에서 줄바꿈 문자를 모두 제거하기
:%s/\n//
# 임의의 글자수를 찾고 찾은문자열 + 줄바꿈 문자로 대치하기
:%s/\(.\{64\}\)/\1\r/g
```

위 첫 번째 치환은 간단합니다. '\n'줄바꿈문자를 찾아서 ''로 대체합니다. 즉, 줄바꿈문자를 지워 한줄로 만듭니다.

두 번째 치환은 제가 잘 안해보던 것이라 좀 시간이 걸렸습니다.
1. '\(\)' 임의의 찾은 문자열을 대체될 영역에서 사용할 때 사용하는 구문입니다. '\1' 형태로 참조하여 사용했습니다.
2. '\{\}' 바로 앞 문자(현재는 임의문자('.'))의 반복 횟수를 나타냅니다.

즉, 임의의 문자가 64번 반복되는 패턴을 찾은 후, '\1\r'형태로 해당문자와 줄바꿈문자로 대체하였습니다.


일부 메일에서 base64인코딩이지만, 글자수가 openssl과 호환되지 않는 형태로 오는 메일을 다뤄본 후 간단히 작업해본 vim 경험입니다.

ps. 검색어 : vim 문자반복 치환 문자갯수 줄바꿈
