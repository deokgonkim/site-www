---
# Title of your post. If not set, filename will be used.
title: "GPG Subkey 분실 및 Revocation 정리"
date: 2026-03-03T17:00:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "GPG"
  - "PGP"
---

## 📌 상황 요약

- Encryption subkey의 **private key를 분실**
- 로컬에서 `delkey`로 subkey 삭제
- 이후 새로운 sign/encrypt subkey 생성
- `gpg --send-keys` 했는데 이전 subkey 삭제가 반영되지 않는 것처럼 보임

---

## 🔐 핵심 개념

### 1️⃣ OpenPGP Keyserver는 기본적으로 Append-Only

- 한 번 업로드된 key material은 **삭제되지 않음**
- 삭제 대신 **Revocation(폐기)** 만 가능
- keyserver마다 동기화/캐시 차이 존재
<!--more-->
즉:

> "삭제"는 로컬 개념이고  
> 공개 세계에서는 "폐기(revoke)"만 의미가 있음

---

## 🔑 Revocation 구조 이해

Subkey revocation은 subkey가 직접 서명하는 것이 아님.

```
Primary Key
  ├─ Subkey A
  ├─ Subkey B
  └─ Revocation signature (by Primary over Subkey A)
```

- Revocation 서명은 **Primary Secret Key**가 생성
- Subkey private part는 필요 없음

---

## ❗ 중요한 조건

Revocation을 만들려면:

- subkey의 fingerprint
- subkey binding 정보
- subkey public packet

이 정보가 **로컬 키링에 존재해야 함**

---

## 🔎 경우의 수 정리

|상태|Revocation 가능 여부|
|---|---|
|subkey private 없음|✅ 가능|
|subkey public 있음|✅ 가능|
|subkey public도 삭제|❌ 바로는 불가|
|keyserver에 남아 있음|✅ recv 후 가능|
|어디에도 없음|revoke 필요 없음|

---

## 🛠 현재 상황 대응 방법

### ✅ 1. Keyserver에서 다시 받아오기 (권장)

```
gpg --recv-keys <PRIMARY_FPR>
```

그 후:

```
gpg --edit-key <PRIMARY_FPR>
gpg> key N
gpg> revkey
gpg> save
gpg --send-keys <PRIMARY_FPR>
```

전제 조건:
- 해당 subkey를 과거에 `--send-keys` 했어야 함

---

### ❌ 2. 한 번도 업로드 안 했고 로컬에서도 삭제한 경우

- 세상 어디에도 존재하지 않음
- revoke 필요 없음
- 그냥 잊어도 됨

---

## 🔄 Subkey 분실 후 새 Subkey 추가는 문제인가?

> 전혀 문제 없음. 오히려 정상적인 키 운영 방식.

OpenPGP 권장 구조:
- Primary key는 오프라인 보관
- Subkey는 교체 가능한 운영 키
- Subkey는 주기적으로 교체 가능

---

## ⚠️ Revocation을 하지 않으면 생기는 문제

- 다른 사람이 예전 encryption subkey로 암호화
- 복호화 불가능
- 메시지 손실 발생

따라서:
> 분실한 encryption subkey는 반드시 revoke 권장

---

## 🧠 최종 핵심 요약

- Revocation은 Primary key가 수행
- Subkey private part는 필요 없음
- 하지만 subkey public packet은 필요
- 로컬에 없으면 keyserver에서 다시 받아와야 함
- 완전히 사라졌다면 revoke 불가 (그리고 불필요)

---

## 🔐 실무 Best Practice

1. Primary key는 오프라인 보관
2. Subkey는 만료기간 설정
3. Subkey 분실 시:
    - 새 subkey 생성
    - 기존 subkey revoke
    - `--send-keys`
4. 주기적 `--refresh-keys`

#gpg #site-published 
