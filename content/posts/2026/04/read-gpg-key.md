---
# Title of your post. If not set, filename will be used.
title: "Read Gpg Key"
date: 2026-04-10T11:00:00+09:00
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

GPG 공개키 `.asc` 파일은 ASCII-armored 형식이라서 내용을 확인하거나 해석할 때 아래 명령어들을 사용하면 됩니다.

---

## 🔍 1. 공개키 내용 보기 (사람이 읽을 수 있게)

```shell
gpg --list-packets file.asc
```

- 내부 구조(패킷 단위)를 자세히 분석해서 보여줌
- 키 ID, 서명, 사용자 ID 등 확인 가능

---

## 👤 2. 키 정보 간단히 보기

```shell
gpg --show-keys file.asc
```

또는

```shell
gpg --with-fingerprint file.asc
```

- 키 ID, 사용자 이름(email), fingerprint 확인 가능

---

## 📥 3. 키를 키링에 import

```shell
gpg --import file.asc
```

- 로컬 GPG 키링에 등록됨

---

## 📋 4. 이미 import된 키 확인

```shell
gpg --list-keys
```

---

## 🔐 5. fingerprint 확인 (신뢰 검증용)

```shell
gpg --fingerprint
```

---

## 📄 6. 그냥 텍스트로 보기 (원본 확인)

```shell
cat file.asc
```

- `-----BEGIN PGP PUBLIC KEY BLOCK-----` 형태 확인 가능
    

---

## 💡 상황별 추천

- 👉 구조 분석: `--list-packets`
- 👉 사람 친화적 정보: `--show-keys`
- 👉 실제 사용: `--import`
