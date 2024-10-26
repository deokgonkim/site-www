---
# Title of your post. If not set, filename will be used.
title: "현재 사용중인 메일(+웹메일)의 기술적 지원사항."
date: 2011-02-05T19:53:00+09:00
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

현재 제가 사용하는 메일의 기술적 지원 사항을 나열해 봅니다.

### 메일

기본적인 메일 서버로서의 고려사항.

1. SMTP/SMTP with SSL : 사용가능. 단, 현재 IP주소를 ISP의 가정용(?) 대역이라 일부 메일 서버에서는 차단될 수 있습니다.
2. POP3/POP3 with SSL : POP3는 제공하는 기능의 한계로 인해 사용하지 않습니다.
3. IMAP/IMAP with SSL : IMAP with SSL로 기본적으로 접근하여 사용합니다.
4. Authentication : LDAP 연동하여 계정인증을 하고 있습니다.
5. Accounting : LDAP에 연계하여 사용하면 좋을 것이나, 현재는 unix 계정에 연계하여 메일을 받고 있습니다. ( 혹, 바꿨나 기억나지 않네요. )
6. Mail box : 편지함의 경우 개인 받은 편지함의 경우 수동으로 생성하며, 한번 생성후 자신의 편지함은 본인이 생성 및 삭제 가능합니다.
7. Mailbox sharing : 개인의 받은편지함 및 개인이 생성한 편지함에 대하여 편지함 단위로 개별 사용자에 대한 권한을 줄 수 있습니다. 단, 사용자가 관리하는 인터페이스는 없고, unix 명령으로만 해봤습니다.
8. group mail : 메일링 리스트와 같은 group mail은 unix에서 임의로 생성하여 사용하는 것은 가능하나, 관리가 편리한 메일링 프로그램과 연계는 하지 않았습니다.
9. SPAM Filter : 현재 서버측 스팸필터는 사용하지 않습니다. 클라이언트에서 thunderbird에서 제공하는 스팸 필터를 사용하고 있습니다.

### 웹메일과 소소한 기능

웹메일에서 기능으로 중시여기는 것들.

1. Authentication : LDAP백엔드를 사용하며, Web form 인증을 사용합니다.
2. 메일서버 선택 : 메일 백엔드 서버는 현재 웹메일 관리 페이지에서 지정할 수 있으며, 지정된 서버목록에서 사용자가 선택하여 로그인 가능합니다. ( 당연히, 메일서버는 IMAP 등으로 연계됩니다. )
3. 주소 : 주소록프로그램과 연계되어 사용되며, 주소록은 LDAP 백엔드를 사용하여 사용중입니다. 메일 작성시 이름을 입력하여 자동으로 주소와 연계하는 것은 가능하나, 한글에 대해서는 기대되는 성능을 내지 못합니다.
4. HTML 메일 : 자체 HTML에디터(html+css+javascript)를 제공하며 사용자가 선택하여 사용가능합니다.
5. SMIME 메일 : 개인 인증서를 통해서 SMIME 서명 및 암호화 메일을 발송할 수 있습니다. LDAP에 사용자 인증서를 등록한 경우, 메일 작성시 캐시에 없을 경우 LDAP에 자동으로 접근하여 인증서를 가져옵니다.
6. PGP 메일 : PGP 가능하나 현재 PGP 키를 잘 사용하지 않고 있습니다.
7. SPAM Filter : 자동화된 스팸 차단 기능은 사용하지 않으며, blacklist등을 통해서 filtering은 가능합니다.
8. Filtering : 개인이 보인의 메일 필터 규칙을 추가하여 사용 가능합니다.
9. 찾기 : 찾기 인터페이스를 통해서 검색은 가능하나, 한글이나 첨부파일에 대한 검색은 잘 안되리라 생각되며, 웹메일의 검색 기능보다는 thunderbird와 같은 클라이언트 프로그램에서 주로 검색합니다.
10. RSVP : 자체 캘린더를 제공하며, RSVP 초대 메일에 대한 연계 기능을 제공합니다.
11. 대용량 메일 : 첨부파일이 대용량인 경우 서버에 파일을 저장하고 링크를 보내는 대용량 메일 기능을 제공합니다.
12. 첨부파일 지원 : zip 첨부파일의 경우 자체 압축해제를 통해 웹으로 zip파일에 포함된 파일 목록을 볼 수 있습니다. 단, 한글 파일명에 대해서는 제대로 동작하지 않습니다.
13. 납치태그 : 기본적으로 메일보기에서는 plain text형태로 보여주며, html 메시지의 경우 이미지 차단이나 납치태그에 대한 차단이 기본적으로 제공됩니다.
14. 드래그앤드롭 파일업로드 : 메일작성시 아직은 드래그앤드롭으로 파일첨부가 불가능합니다.

ps. 이 글은 제가 생각하기에 필요하다고 느끼는 것에 대하여 간추려 올린 것입니다. 추가적으로 필요하다고 생각되는 것이 있으시면, 주저 없이 코멘트 달아 주십시오.
