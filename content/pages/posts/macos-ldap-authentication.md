---
# Title of your post. If not set, filename will be used.
title: "MacOS LDAP Authentication"
date: 2021-06-08T17:10:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Open Source"
  - "ldap"
  - "apple"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

I configured iMac to use My OpenLDAP server. There were several problems.

I will not talk about configuring 'Directory Utility'. (If you know how to configure LDAP server and the basic method of configuring LDAP client, you will not have much difficulty in configuring LDAP client using 'Directory Utility')

 	1. First, try to switch user using sudo su command like 'sudo su - dgkim', there was problem accessing dgkim's home directory. no such directory.

 	  1. /home directory is reserved by mac os, so you need to change home directory to '/Users'

 	    1. Change mapping for 'Users/NFSHomeDirectory' using 'Directory Utility' : Change Users/NFSHomeDirectory from 'homeDirectory' to '#/Users/$uid$'
 	    2. See the page [1]
 	    3. there were several other topics, to use auto_mount NFS volume as home directory(this case I need NFS server that I don't have), or disable auto_mount and symlink /Users to /home (but it wasn't the answer what I was looking for.)


 	  2. /Users/dgkim directory will not be created automatically

 	    1. Use LoginHook to create user's home directory. login hook can be created with 'defaults write com.apple.loginwindow LoginHook /path/to/hookscript.sh'
   	  2. I followed instructions on page [1] YOU SHOULD KNOW WHAT THE SCRIPT DOING.
   	  3. This only works with login screen, it means if you try to access via ssh for the first time, it will not work.

 	2. Second, try to su from local user like 'su - dgkim', the password authentication failed.

 	  1. The mac os tries to authenticate the user with mechanism that can't be used at server. It may not be the problem of mac os, It may caused by openldap. I don't exactly know clean answer. [2]
 	  2. This problem was long unsolved problem for me. When I change olcSaslSecProps, the EXTERNAL method is blocked. (it isn't acceptable.)
 	  3. I tried first method of [2], I configured 'olcSaslSecProps', then the local command like 'ldapsearch -Y EXTERNAL', stopped working. It means the root user can't change or control, the server configuration(by ldapmodify). It took several hours, I researched "How can I disable only '*-MD5' and use only 'LOGIN or PLAIN'"
 	  4. but the answer was below, in the page [2], there is a instruction to change access control list.
 	  5. The page [2] shows static config (like 'slapd.conf'), but I uses dynamic(?) configuration '/etc/ldap/slapd.d/cn=config'. Modifying using ldif file can't be difficult.
 	  6. The page [3] is similar answer.

[1] : https://docs.foxpass.com/docs/mac-os-x-logins-over-ldap
[2] : https://serverfault.com/questions/916745/unable-to-authenticate-openldap-users-on-macos-clients-user-not-found-no-secre
[3] : https://www.chriscantwell.co.uk/2009/12/mac-osx-authentication-against-openldap/

<hr>

### Mac OS ldap client testing scripts

```bash
# this will clear cache?
dscacheutil -flushcache
# Query user name
dscacheutil -q user -a name dgkim
```

ldapsearch, and ldapwhoami command

```bash
# to check login methods
# Run from server, using EXTERNAL mech, to login as root(uid=0)
ldapsearch -H ldapi:/// -Y EXTERNAL -s base -b "" -LLL "+" | grep -i sasl

# on the other machine, If you configured [2] instructions, it will print nothing
ldapsearch -H ldaps://ldap.domain/ -x -W -s base -b "" -D uid=yourusername,ou=Users,dc=domain -LLL "+" | grep -i sasl
```

```bash
# ldapwhoami
# Run from server, using EXTERNAL mech
ldapwhoami -H ldapi:/// -Y EXTERNAL
# will display 
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
dn:gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth

# On the other machine, I use simple bind method to login
ldapwhoami -H ldaps://ldap.domain/ -x -D uid=yourusername,ou=Users,dc=domain -W
# will display
dn:uid=yourusername,ou=Users,dc=domain
```

### login hook to create user

```bash
#!/bin/bash
LOGFILE=/var/log/loginhook.log
echo "$(date) Login hook executed for user $1" >> $LOGFILE

if [ ! -z "$1" ] && [ "_mbsetupuser" != "$1" ] && [ ! -d /Users/$1 ]; then
  echo "$(date) Adding user $1" >> $LOGFILE
  mkdir -p /Users/$1
  /usr/sbin/chown $1:staff /Users/$1
  /System/Library/CoreServices/ManagedClient.app/Contents/Resources/createmobileaccount -n $1 -v >> $LOGFILE
fi
```

```
sudo defaults write com.apple.loginwindow LoginHook /Library/Management/FoxpassLoginHook.bash
```
