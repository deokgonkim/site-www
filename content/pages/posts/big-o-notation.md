---
# Title of your post. If not set, filename will be used.
title: "Big-O notation"
date: 2017-12-14T21:37:00+09:00
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

(S3 * N^3) + (S2 * N^2) + (S1 * N) + S0

중첩된 루프 구조를 가질 때, 문장의 수행 횟수를 구하는 위 공식에서,
S0은 가장 루프 바깥의 문장이며,
S1은 1단계 루프 내의 문장
S2는 2단계 루프 내의 문장
S3은 3단계 루프 내의 문장
N은 반복 횟수를 의미 합니다.

그래서, Big-O 표기법으로, 위의 문장은 O(N^3)로 표기할 수 있습니다?

C/S 과정을 정식으로 배운 것이 아니라, 오늘 책에서 본 내용을 간략히 정리해 봅니다.
