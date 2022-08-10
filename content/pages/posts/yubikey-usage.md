---
# Title of your post. If not set, filename will be used.
title: "Yubikey 이메일 인증 및 전자서명용으로 사용해보다."
date: 2017-11-24T18:57:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "gadget"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

yubikey 질렀었지요.

오늘은, 그동안 사용하지 않았던, 개인인증서를 다시 써볼까 싶어서 잠시 시간을 내었습니다.

comodossl에서 해보자.

https://www.comodossl.co.kr/certificate/Secure-Email-Stages.aspx
국내 리셀러?를 통하지 않고 comodo에서 바로 온라인으로 구매합니다.

https://secure.comodo.net/products/frontpage?area=SecureEmailCertificate&currency=USD&region=Asia%20%26%20Pacific&country=KR%20

이름, 이메일 주소를 입력하면, 인증서를 발급 받을 수 있습니다.

개인용 이메일 인증서는 무료로 제공하지요.

별도의 심사 같은 것 없고, 딱 위에 입력한 것만으로 발급이 바로 진행됩니다.

발급시에는 yubikey로 바로 넣는 것이 아닌, 소프트웨어 인증서 저장소를 택했습니다.
(혹시나 핸들링에 문제가 있을까 싶어서)

그리고, 인증서를 파일로 백업한 후, PIV Manager 통해서 다시 넣었습니다.

Firefox, Thunderbird에서 모두 yubikey에 있는 인증서가 잘 접근 됩니다.

그러나, opensc와 yubikey조합에서는 인증서 백업과 같은 것은 정상 동작하지 않습니다.참고하십시오.

firefox에 인증서를 넣어두고, openoffice에서 문서 서명을 해봅니다.
잘 됩니다.

thunderbird에 인증서를 넣어두고, 전자 서명메일을 발송해 봅니다.
잘 됩니다.

이메일이나 문서 서명의 경우, 기한을 가지더라도 큰 문제가 안 되는데,
파일 시스템 암호화의 경우는, 인증서를 쓰면 좋긴 한데,
아직까지 개인인증서 1년짜리는 문제가 좀 있다 싶고,
별개의 영역으로 다루어야 할 것 같긴 합니다.

Vostro 260s에는 yubikey로 로그인을 보호하고,
ecryptfs를 통해 파일시스템 암호화를 수행하여 보호합니다.
ecryptfs가 인증서를 지원할지는 미지수 ...
