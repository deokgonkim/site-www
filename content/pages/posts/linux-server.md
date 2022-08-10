---
# Title of your post. If not set, filename will be used.
title: "서버 구축 노트."
date: 2017-10-03T14:36:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "linux"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

이번에, www 서버를 이전하였다.
그래서, 이 작업에서 수행한 작업들을 메모해 보고자 한다.

목표는, wordpress 웹서버이다. (MariaDB도 같은 서버에 구동한다.)

1. Linode 서버 구매.
2. Debian 9 이미지 세팅.
3. sudo 권한 가진 사용자 생성. - Ubuntu, AWS 같이 root를 바로 사용하지 않으려고,
4. ssh 키세팅. - root, 관리자 두 계정에 대해서, 모두 비밀번호를 사용하지 않고, ssh 키인증을 한다.
5. hostname 설정 - hostnamectl
6. timezone 설정 - timedatectl
7. logwatch + postfix 설치 - logwatch를 통해, 서버 상황 데일리 리포트를 받아보면서 건강한지 확인한다.
8. root 메일 수발신 테스트
9. 방화벽 설정 - 이번에는 firewallcmd 말고, ufw를 사용해 보기로 하고, ufw 설치 및 허용포트 오픈.
10. mariadb-server 설치
11. apache 설치
12. certbot 설치 및 SSL 세팅.
13. libapache2-mod-php7.0 및 php7.0-mysql, php7.0-ldap 설치
14. 유틸리티 설치. ( netstat, mailutils .. )

15. mariadb dump.sql 파일 통해서 DB 복구, wordpress 사용자 생성
16. wordpress 파일 이전.
17. wordpress 구성 점검.

이슈 사항.
백업을 암호화해서 보관했었다. mysqldump | openssl enc -e > dump.sql.enc
그런데, 악 ㅋㅋ 복구가 안되 openssl 버전이 달라서 안되는지 뭔지...
그래서, 아래와 같은 기술을 사용.

1. 기존 백업 볼륨이 있는 서버를 ubuntu stick을 통해서 복구용으로 부팅한다.
2. 기존 백업 볼륨의 OS 영역을 read-only 복구용으로 마운트 한다.
3. OS 영역을 chroot해서 구버전 openssl 사용할 환경으로 만들고, 암호화된 백업을 복구해 본다.
4. chroot 하고, read-only 라서, 복구한 파일을 백업 볼륨에 만들 수는 없다. ( 물론, 이동식 저장장치를 쓴다거나 할 수 있지만 귀찬다. )
5. 그래서, ... 아주 오래되었지만, 여전히 유효한 기술인 유닉스 파이프를 활용하는 걸로 복구를 진행한다. 로컬에서 복호화 돌리고, ssh 채널로 전송하면서, 파일로 쓰기, ... 오랜만에 해본 것인데, ... 역시 유닉스는 강력하다는 것을 또 느낀다.

추가 이슈.
wordpress가 첫 페이지 뜰 때는, 몰랐는데, 글 작성하고 링크를 공유하려니, rewrite가 안 먹는다.
rewrite 모듈 확인하고, .htaccess 확인. 문제없는데? 지만, 아래를 참조하여 수정함.
https://stackoverflow.com/questions/22797931/htaccess-is-not-working-in-linuxdebian-apache2
