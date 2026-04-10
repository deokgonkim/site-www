---
# Title of your post. If not set, filename will be used.
title: "Gpg Sign"
date: 2026-04-10T11:10:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 20

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - gpg
---

## *sign*

원문 및 서명이 포함된 파일이 생성된다. (armor 옵션을 빼면, 바이너리 파일 .gpg 생성된다.)

```shell
gpg --sign --armor message.txt
```

출력 예시

```
-----BEGIN PGP MESSAGE-----

owEBYAGf/pANAwAKATrqddgZ8snwAawZYgttZXNzYWdlLnR4dGmhP7PtlZjsnbRh
CokBMwQAAQoAHRYhBO7v3zK+DnU1GvdrvTrqddgZ8snwBQJpoT+zAAoJEDrqddgZ
8snwuXMH/Rv9E/I5gfMRO9oC+VBzGD+EUg1FimDvKykGL9Q3nUWvz4dTRcs+cBW/
OXOhmiYR9IVH0LC+1h8rgZSEji17MuNqI0MrOMahqjCSg1qEXoaghs5vgze2Dn8K
ChNv7RVxG7iqCeqGinn+fcRYgKT0AhivU6BI+jrJAtp8fCwC2ZcY2JAbgtjNYvpQ
h3Nn7bPsRZzA4kOvJpIc3KZafUW/3TQHuPclD/RfB3XqMNvO/NZHQhgCVQteqY93
JdN5b6Fd4A4k4KLFQkDn5HHkkjRetkmR6fL57abkJWO2L+MeSxdx/YOlQUK5uauw
vCkEYrtQ1F35sKewHCzzh/8VumlK3Ms=
=c+/E
-----END PGP MESSAGE-----
```

## *clearsign*

원문을 읽을 수 있는 형태로 표시하고 서명 파일이 생성된다. (clearsign은 별도로 armor옵션이 없어도, text로 생성된다.)

```shell
gpg --clearsign message.txt
```

출력 예시

```
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

하이a
-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEE7u/fMr4OdTUa92u9Oup12BnyyfAFAmmhP/QACgkQOup12Bny
yfB4LAgAoJrv6OR1XwCgV4h/o/vgb07G+2zRs2pIho6gNtC7QNG+emypVlgkafp8
fyediNlSK9rxD4mjHcAx7kDJgpJOw2YBkVFN2K8iKyoiX+njNkGzmha7K0DnCPM/
8ZA4FFy9KihJIQxwwgCVAUBb6QKhwjBnbuAtb6TmFLkZlcYG693jLmJRd87EbG/6
G+6byU4DDB950gHdvMnKTx4L+jmEENK/l8Hxyn4htj9PNcGGrLFsuCR9eKeuNEqa
E6nzwypv5eR0BZnrj2KP7K1JMUYmZZWmK25A/VcxMQE/7T5Rd++R6plmwGfGHNgx
fmgrZbvTKbtZX4IAIYIAo5c0P0k4cA==
=WF6U
-----END PGP SIGNATURE-----
```

## *detach-sign*

원문 파일을 별도의 파일로 두고, 서명부만 분리된 파일로 만든다. (파일 배포용으로 가장 많이 사용됨)
(armor 옵션이 있으면, 텍스트 asc 파일, 없으면 바이너리 sig 파일이 생긴다)

```shell
gpg --detach-sign --armor message.txt
```

출력 예시

```
-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE7u/fMr4OdTUa92u9Oup12BnyyfAFAmmhQLcACgkQOup12Bny
yfCQtgf/eFbqKKq+0JoqLBzK6O/KsyU9dpPIAY7JRmqgrt2VzvdgqHpwaMURF8K+
FSi370gZ70Shgtg7aQYCrusFJ42DJQF0hPumiDbrYISkM7Tg1P0qBrHof9/dlu9M
s2pdCc+NTPtgf2vXwacDPzge5nTFyHlMcn0xOD+6OQy97CCb2PRiT/ttDxPkPOjn
N2VNY5cFFqd6z1YQXS9+3YNEPemOBi4OgvRp4PPdj2rrWaKTdsPBz/opxF4SwWlJ
Pu7WmuDbSU8v0zUJqX0+dyolaP9Jk6ixl6rO4ytF8pk3X0MQbeAXvLEVcLyHTFiV
eZlXYtJYVg82T292IUfZMhCv+4Q0cQ==
=tO/o
-----END PGP SIGNATURE-----
```

---

## *verify*

사용시에는, message.txt.asc 검증시 message.txt 파일을 원본으로하여 검증된다.
파일명을 달리 할경우, 인자로 주어 아래와 같이 검증이 가능하다.

```shell
gpg --verify message.txt.asc message2.txt
```
