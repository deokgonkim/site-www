---
# Title of your post. If not set, filename will be used.
title: "netsh를 통한 ip주소 세팅 스크립트"
date: 2011-08-01T14:05:00+09:00
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

리눅스에서는 이미 네트워크 설정에 프로필(?) 기능이 있어서, 노트북과 같이 이동하는 장비에서 IP설정(IPv6에서는 달라지겠지만)을 기록해 두는 기능이 있습니다.

저와 같이 여러 사이트를 방문하는 엔지니어에게는 IP주소 세팅이 업무의 시작이라 할 수 있습니다.

보통은 ipchanger같은 툴을 통해서 프로필 기능과 비슷하게 활용하고 계실 것입니다.
( 저는 ip를 메모해두고 윈도우 자체네트워크 설정으로 일일이 입력합니다만.. )

netsh 명령을 통해서 프로필 기능과 비슷한 시도를 해보았습니다.

아래 명령을 쉘스크립트로 작성하여 사용하는 방법입니다.

```bat
@echo off
set INTERFACE="eth0"
set IPADDRESS=192.168.20.10
set NETMASK=255.255.255.0
set GATEWAY=192.168.20.254
set PRIDNS=168.126.63.1
set SECDNS=168.126.63.2

netsh ^
interface ip ^
set address ^
name=%INTERFACE% ^
source=static ^
addr=%IPADDRESS% ^
mask=%NETMASK% ^
gateway=%GATEWAY% ^
gwmetric=0

netsh ^
interface ip ^
set dns name=%INTERFACE% ^
source=static ^
addr=%PRIDNS% ^
register=NONE

netsh ^
interface ip ^
add dns ^
name=%INTERFACE% ^
addr=%SECDNS% ^
index=2

netsh interface ip show config name=%INTERFACE%

pause
```

아래는 ini컨피그를 사용하는 확장판.

```bat
@setlocal enableextensions enabledelayedexpansion
@echo off
@rem change below configurable parameters.
set INTERFACE="eth0"
set file=ipaddress.ini
set DHCPKEY=DHCP
set IPADDRESSKEY=IPADDRESS
set NETMASKKEY=NETMASK
set GATEWAYKEY=GATEWAY

set IPADDRESS=
set NETMASK=
set GATEWAY=
set DHCP=
set PRIDNS=168.126.63.1
set SECDNS=168.126.63.2

set currarea=
set i=0
for /f "delims=" %%a in (!file!) do (
    set ln=%%a
    if "x!ln:~0,1!"=="x[" (
        set /a i=!i!+1
        set currarea=!ln!
        echo !i!. !currarea!
    )
)

set /a i=0

set /p choose=Choose profile : 

for /f "delims=" %%a in (!file!) do (
    set ln=%%a
    if "x!ln:~0,1!"=="x[" (
        set /a i=!i!+1
    ) else (
        for /f "tokens=1,2 delims==" %%b in ("!ln!") do (
            set currkey=%%b
            set currval=%%c
            if "x!choose!"=="x!i!" (
                if "x!currkey!"=="x!DHCPKEY!" (
                    set DHCP=!currval!
                )
                if "x!currkey!"=="x!IPADDRESSKEY!" (
                    set IPADDRESS=!currval!
                )
                if "x!currkey!"=="x!NETMASKKEY!" (
                    set NETMASK=!currval!
                )
                if "x!currkey!"=="x!GATEWAYKEY!" (
                    set GATEWAY=!currval!
                )
            )
        )
    )
)

if "x!DHCP!"=="x" ( 
    netsh ^
    interface ip ^
    set address ^
    name=%INTERFACE% ^
    source=static ^
    addr=%IPADDRESS% ^
    mask=%NETMASK% ^
    gateway=%GATEWAY% ^
    gwmetric=0
) else (
    netsh ^
    interface ip ^
    set address ^
    name=%INTERFACE% ^
    source=dhcp
)

netsh ^
interface ip ^
set dns name=%INTERFACE% ^
source=static ^
addr=%PRIDNS% ^
register=NONE

netsh ^
interface ip ^
add dns ^
name=%INTERFACE% ^
addr=%SECDNS% ^
index=2

netsh interface ip show config name=%INTERFACE%

pause

endlocal
```

```
[DHCP]
DHCP=yes

[회사]
IPADDRESS=192.168.20.18
NETMASK=255.255.255.0
GATEWAY=192.168.20.254

[집]
IPADDRESS=192.168.10.18
NETMASK=255.255.255.0
GATEWAY=192.168.10.254
```