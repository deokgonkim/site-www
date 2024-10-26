---
# Title of your post. If not set, filename will be used.
title: "mysql root 패스워드 까먹었을 때."
date: 2010-07-20T10:27:00+09:00
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

mysql root 패스워드를 까먹었을 때. 복구하는 방법......

구글링한다.

<a href="http://www.google.com/search?q=mysql+root+password+recovery">http://www.google.com/search?q=mysql+root+password+recovery</a>

첫 번째 링크를 클릭한다.
OS에 맞는 링크를 클릭한다.

아래와 같은 명령으로 복구한다.
( 아래는 ubuntu 예제 )

```bash
# cat > /tmp/rootpassword.sql
UPDATE mysql.user SET Password=PASSWORD('password') WHERE User='root';
FLUSH PRIVILEGES;

# kill `cat /var/run/mysqld/mysqld.pid` && sleep 3 && ps -ef | grep mysql && mysqld_safe --init-file=/tmp/rootpassword.sql &
```
