---
# Title of your post. If not set, filename will be used.
title: "OCSP 검증해보기"
date: 2013-11-18T19:49:00+09:00
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

오늘 StartSSL에서 인증서를 발급 받았습니다.

그런데, firefox에서 접근하니 OCSP 검증이 잘 안되는지 에러페이지가 아래와 같이 뜨는 것입니다.

```html
<div>
<h3>보안 연결 실패</h3>

<p>www.dgkim.net에 접속하는 중에 오류가 발생했습니다.</p>
<p>OCSP 서버가 인증서에 대한 상태를 유지하고 있지 않습니다.</p>
<p> (오류 코드: sec_error_ocsp_unknown_cert) </p>

<ul>
    <li>받은 데이터의 내용 사실 검증을 할 수 없기 때문에 보려고 시도하신 페이지를 보여드릴 수 없습니다.</li>
    <li>웹 사이트 관리자에게 현재 문제를 알려 주시거나, 다른 방법으로 도움말 메뉴의 웹 사이트 문제 보고를 이용해 주시기 바랍니다.</li>
</ul>
</div>
```

그래서, ocsp 검증을 해보기로 했습니다. [1]

```bash
$ openssl ocsp \
> -issuer level1.crt \
> -url http://ocsp.startssl.com/sub/class1/server/ca \
> -no_nonce \
> -cert level0.crt
Error querying OCSP responsder
17384:error:27075072:OCSP routines:PARSE_HTTP_LINE1:server response error:/SourceCache/OpenSSL098/OpenSSL098-50/src/crypto/ocsp/ocsp_ht.c:224:Code=400,Reason=Bad Request
$
```

level1.crt : intermediate CA인증서
level0.crt : 검증해볼 서버인증서
url : 서버인증서에 ocsp url이 있습니다.

서버가 400 bad request라고 하네요. 잘되는 kldp사이트 인증서로 해도 에러가 나는 것입니다.
startssl openssl ocsp 확인해 보니, openssl과 startssl 호환 문제가 있는 것이 확인됩니다. [2]
openssl이 Host헤더를 보내지 않아서, akamai를 쓰는 startssl에서 안 되는 것입니다.

tcpdump를 떠보니 http요청이지만, post내용이 바이너리입니다.
즉, 간단한 telnet으로는 할 수 없다.

openssl에서는 아래 방법으로 ocsp request를 파일로 떨굴수 있습니다.

```bash
$ openssl ocsp \
> -issuer level1.crt \
> -url http://ocsp.startssl.com/sub/class1/server/ca \
> -no_nonce \
> -cert level0.crt \
> -reqout req.der
```

그러면, 이제 위에서 떨군 파일을 http post 해봅니다. telnet으로는 안되고, curl을 사용합니다.

```bash
$ curl \
> --header "Host: ocsp.startssl.com" \
> --header "Content-Type: application/ocsp-request" \
> http://ocsp.startssl.com/sub/class1/server/ca \
> -v \
> --upload-file req.der \
> --request POST > response.der
```

host 헤더를 넣어주었습니다.
content-type을 tcpdump에서 확인했던 것으로 넣었습니다.
upload-file을 통해서 binary 내용을 올릴 수 있습니다.
request에서 POST를 넣어준 것은 upload-file이 PUT을 사용하기 때문입니다.

이제, ocsp응답을 response.der 파일로 받았습니다.

다시 한번 ocsp명령으로 response를 까봅니다. (물론 바이너리 파일입니다.)

```bash
$ openssl ocsp \
> -respin response.der \
> -CAfile cabundle.pem \
> -text
OCSP Response Data:
    OCSP Response Status: successful (0x0)
    Response Type: Basic OCSP Response
    Version: 1 (0x0)
    Responder Id: C = IL, O = StartCom Ltd. (Start Commercial Limited), CN = StartCom Class 1 Server OCSP Signer
    Produced At: Nov 18 00:34:46 2013 GMT
    Responses:
    Certificate ID:
      Hash Algorithm: sha1
      Issuer Name Hash: 6568874F40750F016A3475625E1F5C93E5A26D58
      Issuer Key Hash: EB4234D098B0AB9FF41B6B08F7CC642EEF0E2C45
      Serial Number: 0CFD8F
    Cert Status: unknown
    This Update: Nov 18 00:34:46 2013 GMT
    Next Update: Nov 20 00:34:46 2013 GMT
```

응답을 받았습니다. 헛, 그런데 cert status가 unknown이네요?

  - http://backreference.org/2010/05/09/ocsp-verification-with-openssl/
  - https://forum.startcom.org/viewtopic.php?f=15&t=2661
