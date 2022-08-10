---
# Title of your post. If not set, filename will be used.
title: "LDAP 서버에서 CRL 받는 방법"
date: 2010-10-14T14:32:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "ldap"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

LDAP 서버에서 인증서 폐기 목록(CRL) 받는 방법 노트.

일반적인 LDAP 조회로는 CRL을 접근할 수 없으므로 아래와 같은 명령으로 base 서치를 통해 받을 수 있습니다.

```bash
# Unix 명령
ldapsearch \
-x \
-h ds.yessign.or.kr \
-b ou=dp3p49695,ou=AccreditedCA,o=yessign,c=kr \
-t \
-s base \
-v
# or Windows 명령
ldapsearch ^
-x ^
-h ds.yessign.or.kr ^
-b ou=dp3p49695,ou=AccreditedCA,o=yessign,c=kr ^
-t ^
-s base ^
-v
```

ps. -t 옵션을 통해 CRL은 파일로 받아지며, 임시 디렉토리(tmp)에 저장됩니다.
