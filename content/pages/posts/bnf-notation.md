---
# Title of your post. If not set, filename will be used.
title: "BNF Metalanguage"
date: 2017-12-09T16:48:00+09:00
draft: true

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "programming"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

Backus-Naur Form(BNF)
BNF는 John Backus와 Peter Naur의 이름을 딴 것이고, 그들은 BNF를 1960년에 개발했다. BNF 구문 정의를 문자, 숫자, 그리고 특별한 기호를 사용해서 쓰여졌다.

예제.
```
<DecimalInteger> ::= <NonzeroDigit> | <NonzeroDigit><DigitSequence>
<NonzeroDigit> ::= 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
<DigitSequence> ::= <Digit> | <Digit><DigitSequence>
<Digit> ::= 0 | <NonzeroDigit>
```
