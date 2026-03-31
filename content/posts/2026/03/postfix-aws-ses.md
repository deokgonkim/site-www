---
# Title of your post. If not set, filename will be used.
title: "Configuring Postfix to use with AWS SES"
date: 2026-03-31T11:10:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - postfix
---

## Using AWS `SES` to send email from Linux host

I use AWS `SES` to send email to internet from home network.  
So, here is brief configuration note.

## `/etc/postfix/main.cf`

```
# AWS SES SMTP endpoint
relayhost = [email-smtp.ap-northeast-2.amazonaws.com]:587

# enable SASL authentication
smtp_sasl_auth_enable = yes
smtp_sasl_security_options = noanonymous
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd

# enable TLS
smtp_use_tls = yes
```

## Create SMTP Credentials file

create `/etc/postfix/sasl_passwd`
```
[email-smtp.ap-northeast-2.amazonaws.com]:587 username:secret_password
```
> Username and password can be created on AWS Console.


```shell
sudo postmap /etc/postfix/sasl_passwd
sudo chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
sudo chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
```

## Test mail

```shell
echo "SES Relay Test" | mail -s "Test Subject" -r root@testhost.dgkim.net dgkim@dgkim.net
```

## In case host uses other name than FQDN

### ~~THIS NOT WORKING IN MY ENVIRONMENT (ubuntu)~~ 

```
# /etc/postfix/main.cf
myorigin = /etc/mailname
# /etc/mailname should contain official FQDN
```

### Using generic map

- `/etc/postfix/generic`
```
# local     aws ses email
@myhosname  systemmail@example.com
```
- `postmap`
```shell
sudo postmap /etc/postfix/generic
```
- `/etc/postfix/main.cf`
```
smtp_generic_maps = hash:/etc/postfix/generic
```
