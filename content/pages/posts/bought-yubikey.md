---
# Title of your post. If not set, filename will be used.
title: "yubikey를 질렀습니다."
date: 2017-11-16T22:16:00+09:00
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

yubikey를 질렀습니다.
https://www.yubico.com/product/yubikey-4-series/

물론, 해외직구를 하면 좋으나(?) 배송비가 배보다 배꼽이 커서, ... 국내 대행사를 통해서 구매하였습니다.

처음에는, 인증서 저장도 염두에 두었습니다.
(사실, 2FA보다 여기에 무게를 더 두었습니다.)

그리고, 받아서 사용해 볼려고 끄적거렸고,

Mac에서 잘 되었습니다.
하지만, 아직은 Mac로그인용으로는 사용하지 않고,

SMIME인증서 저장으로 활용해 보려 했습니다.

Firefox, Thunderbird에서 라이브러리 설치해서 인식은 하는데, 인증서 저장에서 에러가 발생하더군요.

그리고, OpenOffice에서 서명을 시도했습니다. 마찬가지로, 인식해서 뜨긴 하는데, 인증서는 뜨지 않았고, ...

찾다보니, yubikey에서 제공하는 프로그램에서 인증서를 넣는 것이 보였습니다.
PIV authentication, Digital Sign, Key Management? Card Authentication? 이란 4가지 용도로 인증서를 저장할 수 있다는 것을 보았고, 역시 인증서를 넣어보았습니다.

하지만, 위 4가지 모두, Firefox나 Thunderbird에서는 나오지 않았습니다.

그래서, 걍 포기하고 되는 걸 먼저 해보자 싶어서, ...

가장 먼저 시도한 것이, 잘 쓰지는 않지만, 만들어 두었던 Dropbox ...
거기에 2FA 용도로 등록해 보았습니다.

잘 됩니다. (물론, Chrome에서...)

그리고, 다음으로 구글...

역시 잘 됩니다. (물론, Chrome에서...)

왜 Chrome인지는 모르겠으나, ... Firefox에서는 2FA로 휴대폰 인증을 받더군요 ...

...

그리고, 오늘은 Ubuntu에 시도해 보았습니다.
한시간 삽질했으나, 되긴한다. 라고 알고, 세팅했습니다.

Vostro 260s에 적용했습니다.

...

하는김에 랩톱에도 해보자 싶어서 Libreboot X200에 시도 합니다. ...

프로그램은 있어서 설치되는데, ... 키가 인식되지 않는군요.

소프트웨어 업데이트가 상대적으로 느린 Trisquel 7.0 ... 안 되니, 걍 쉽게 포기했습니다.

...

언젠가 Libreboot X200에 Ubuntu를 깔아버리는 것이 좋을까? ㅋㅋㅋ

...

윈도우에서는 어디까지 되나 시험해 보고 싶으나, 내가 가진 유일한 윈도우였던 Vostro 260s Windows 10은, Ubuntu로 바뀐지라 테스트 해보지 못하고, ...

직장에서는. DLP툴이 차단해서 한번 꽂아보고, 포기. 물론 인터넷이 되지 않는 환경에서 드라이버가 잡힐까 싶긴 하고, ㅋㅋㅋ

...

나중에 PIV인증서를 좀더 파보고 사용할 수 있으면 사용해 보려 합니다.

...

사실 보안PKI 쪽에서는, 서명용으로 포기한 것 같고, 인증에 무게를 두는 것 같은데, ... 대다수 2FA용으로 많이 홍보하고, ...
서명이 그렇게 무효한지는 모르겠으나, ... 나는 써보고 싶은데, ... Letsencrypt에서도 개인 인증서를 발급하지 않으니,
당분간은 authentication에 관심을 둬야 하나 싶고, ...

우분투 로그인은 challenge-response로 했는데, 나중에 시간이 되면, OTP 기능도 좀 파보고 잘 활용해야 되겠ㅋㅋ
