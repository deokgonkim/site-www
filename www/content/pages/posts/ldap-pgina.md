---
# Title of your post. If not set, filename will be used.
title: "pGina를 이용하여 WinXP에서 LDAP로그인 정보 활용하기"
date: 2010-08-10T16:12:00+09:00
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

Windows XP에서 로그인시 로컬 계정이 아닌 LDAP에 있는 계정으로 로그인하는 것을 테스트해 보았습니다.

Windows XP에서는 기본적으로는 LDAP인증을 당연히 제공하지 않고 있지요. ( AD를 구성하면 디렉토리 서버를 통한 인증이 되겠지만 )

구글링한 결과 <a href="http://www.pgina.org/">pGina</a>라는 프로그램을 설치하여 LDAP을 통한 인증이 가능하다는 것을 테스트해 보았습니다.

아래 사이트에서 pGina XP용 버전인 1.8.8 버전을 받습니다.

<a href="http://www.pgina.org/">http://www.pgina.org/</a>

그리고, 아래 URL에서 LDAP 인증 플러그인을 받습니다.

<a href="http://www.pgina.org/index.php/Plugins:LDAP_Auth">http://www.pgina.org/index.php/Plugins:LDAP_Auth</a>

받은 플러그인을 plugin 디렉토리에 넣고, 플러그인 설정에서 <strong>서버주소</strong>(서버명 or IP, SSL 여부, LDAP포트), <strong>PrePend</strong>(ex. uid=), <strong>Append</strong>(ex. ou=Users,dc=dgkim,dc=net)정도만 세팅해주면 테스트가 가능합니다.

재부팅을 하면, XP 자체 로그인화면이 아닌 pGina의 로그인 화면이 나오고, LDAP의 ID, Password로 인증이 가능합니다.

만약 처음 로그인인 사용자인 경우, 사용자 프로파일 생성과정을 거친후 로그인 됩니다.

<hr />

<del datetime="2011-06-05T08:14:26+00:00">제 PC에 사용해 보려고 했으나, 결정적으로 XP의 훌륭한 장점인 Fast User Switching이 사용할 수 없게 되어, 제거해 버렸습니다.</del>

<del datetime="2011-06-05T08:14:26+00:00">Fast User Switching 기능만 사용가능하다면, 한번 써볼만하다고 생각합니다.</del>

<hr />

2011/06/05 잠시 타인에게 노트북 사용권을 주고자 설치했습니다. Fast User Switching 기능이 안되더라도...... 그런데, 오늘 '작업관리자'에서 로그인한 사용자의 접속을 '연결 끊기'를 통해 사용자 전환이 가능하다는 것이 확인되었습니다. ( 조금 불편할 수도 있지만...... )
