---
# Title of your post. If not set, filename will be used.
title: "편리한 LDAP 프로그램"
date: 2010-06-13T19:30:00+09:00
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

LDAP 관리에 사용하는 프로그램 소개

1. Softerra LDAP Browser

    <a href="http://www.ldapbrowser.com/">http://www.ldapbrowser.com/</a>

    가장 먼저 사용한 툴입니다.
    단, LDAP Browser 만 다운로드 받아 사용할 수 있습니다.
    물론, LDAP Browser는 검색만 가능하고 입력 수정이 불가능합니다.
    검색에서는 아래 나오는 툴보다 훨씬 빠르게 작업할 수 있습니다.

2. LDAP Browser Editor

    Jarek Gawor분이 만든 Java버전 LDAP Editor입니다.
    현재는 업데이트가 되지 않는 것으로 보입니다.
    (Apache Directory Studio를 만나기 전에는 이 툴을 사용했었습니다.)

3. phpLDAPadmin

    <a href="http://phpldapadmin.sourceforge.net/wiki/index.php/Main_Page">http://phpldapadmin.sourceforge.net/wiki/index.php/Main_Page</a>
    php로 만들어졌고, 웹기반으로 사용할 수 있습니다.
    최근에는 Ajax로 보강되었으나, Frame을 사용하므로 Ajax가 완전하지는 않아 보입니다.
    웹에서 할 수 있다는 것은 장점이나, 일부 속성을 다루지 못하는 문제가 있습니다.

4. Apache Directory Studio

    <a href="http://directory.apache.org/studio/">http://directory.apache.org/studio/</a>
    현재 제가 사용하고 있는 툴입니다.(최근에 발견했기 때문에 마지막 순번으로 등록하였습니다.)
    Eclipse RCP로 만들어졌으며(?), 사용하기 편리합니다.
    단, 편의성에 비하여 퍼포먼스는 만족할 만한 수준은 아닙니다.
    ( ex. excel 시트형으로 펴두고, 일괄 수정 작업시 체감속도가 느림. )
