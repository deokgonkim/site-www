---
# Title of your post. If not set, filename will be used.
title: "Gpg Backup"
date: 2026-04-10T10:40:00+09:00
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

- [Backup public](#backup-public) : 공유/재배포용
- [Backup secret key](#backup-secret-key) : 개인백업용
- [Backup Sub secret key](#backup-sub-secret-key-exclude-primary-key) : 운영용 키 복사 용도
- [Create revocation certificate](#create-revocation-certificate) : 키 폐기를 위한 용도
---
- [Send to Key server](#send-to-key-server) : 공유/재배포
---

- [Backup to S3](#backup-to-s3) : 2차 백업으로 S3에 올리는 것

## Backup public

**공유/재배포용**

```shell
gpg --export --armor dgkim@dgkim.net > pub.asc
```

## Backup secret key

```shell
gpg --export-secret-keys --armor dgkim@dgkim.net > key.asc
```

## Backup Sub secret key (EXCLUDE PRIMARY KEY)

```shell
gpg --export-secret-subkeys <KEYID> > subkeys.gpg
```
특정 subkey만 백업되는 건 아니고, primary key의 secret을 제외하고 보낸다.
운영환경에서, 사용할 수 있고, subkey add 같은 작업은 할 수 없다.

## Create revocation certificate

```shell
gpg --output revoke.asc --gen-revoke dgkim@dgkim.net
```

---

## Send to Key server

```bash
EMAIL=dgkim@dgkim.net
SHORT_KEY_ID=$(gpg --list-keys --with-colons "$EMAIL" | awk -F: '/^pub/ {print $5; exit}')
#FINGERPRINT=$(gpg --list-keys --with-colons "$EMAIL" | awk -F: '/^fpr/ {print $10; exit}')
gpg --keyserver hkps://keys.openpgp.org/ --send-keys ${SHORT_KEY_ID}
```

---

## Backup to S3

```shell
EMAIL=dgkim@dgkim.net
SHORT_KEY_ID=$(gpg --list-keys --with-colons "$EMAIL" | awk -F: '/^pub/ {print $5; exit}')
#FINGERPRINT=$(gpg --list-keys --with-colons "$EMAIL" | awk -F: '/^fpr/ {print $10; exit}')
BASE_NAME=${EMAIL}_${SHORT_KEY_ID}

S3_BUCKET=backup

aws s3 cp pub.asc s3://${S3_BUCKET}/GPG/${BASE_NAME}/${BASE_NAME}.pub.asc
aws s3 cp key.asc s3://${S3_BUCKET}/GPG/${BASE_NAME}/${BASE_NAME}.sec.asc
aws s3 cp revoke.asc s3://${S3_BUCKET}/GPG/${BASE_NAME}/${BASE_NAME}.revoke.asc
```
