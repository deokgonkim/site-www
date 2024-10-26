---
# Title of your post. If not set, filename will be used.
title: "Ldapmodify Rootdn"
date: 2019-08-03T09:00:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "ldap"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

# How to add root dn for `cn=config`

This document describes how to add `root dn` and `password` for `cn=config` base.

- `manager.ldif`
  ```
  dn: olcDatabase={0}config,cn=config
  changetype: modify
  add: olcRootDN
  olcRootDN: cn=admin,cn=config
  -
  add: olcRootPW
  olcRootPW: {SSHA}blablabla
  ```

- `ldapmodify`
  ```bash
  ldapmodify -Y EXTERNAL -H ldapi:/// -f ./manager.ldif 
  ```

By default, you should configure ldap's configuration using `ldapmodify -Y EXTERNAL -H ldapi:///`

After configuring `olcRootDN` you can modify `cn=config` meta configuration using remote LDAP clients.
