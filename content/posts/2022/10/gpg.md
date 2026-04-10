---
# Title of your post. If not set, filename will be used.
title: "Gpg"
date: 2022-10-25T21:30:08+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - gpg

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

# GnuPG 사용하기

## Create a new key

```bash
gpg --full-generate-key
```

## export

내보내기

```bash
# -a        : output file will be encoded in `base64`
# --export  : export all public keys
gpg -a --export >mypubkeys.asc

# -a                    : output file will be encoded in `base64`
# --export-secret-keys  : export secret keys
gpg -a --export-secret-keys >myprivatekeys.asc

# --export-owntrust : 모르겠다.
gpg --export-ownertrust >otrust.txt

# --gen-revoke : 키 폐기용 인증서 파일을 생성한다.
gpg --output revoke.asc --gen-revoke dgkim@ossfsc.net
```

## import

가져오기

```bash
# --import  : import public keys or private keys
gpg --import myprivatekeys.asc
gpg --import mypubkeys.asc
# -K        : lists secret keys
gpg -K
# -k        : lists public keys
gpg -k

# --import-ownertrust : don't know yet..
gpg --import-ownertrust otrust.txt
```

## ps

요즘은, gpg direct로도 쓰지만, `pass` 사용하면서 gpg를 필수 사용하고 있습니다.
추가로, gpg 키를 yubikey에 저장할 수도 있어서, 참 좋은 생각이라 생각합니다...

[GpgBackup](/posts/gpg-backup/)

