---
# Title of your post. If not set, filename will be used.
title: "2023 Pico PC"
date: 2023-07-10T17:34:17+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "gadget"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

## Bought Pico PC

I bought Pico PC via indiegogo fundraising several months ago.[Oct 2022 - Bought Pico PC](/pages/year-2022/)

Long-waited Pico PC is just arrived today

## First impression

![Pico PC Box front](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-box-01.jpg)

![Pico PC Box back](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-box-02.jpg)

![Pico PC Box inside](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-box-03.jpg)

## Booting the box.

![Pico PC Boot screen](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-boot-01.jpg)

Next. the boring win10 boot sequence starts.. (before installing ubuntu, let's see what is win10, what it looks like)

![I guess windows is starting](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-win10-01.jpg)

(yeah, it is windows 10. I don't need windows 10.)

![windows is forcing me to agree](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-win10-02.jpg)

(long long long time windows 10 on-boarding is completed..)

![windows is taking my precious several time](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-win10-03.jpg)

(xdo windows 10 is looks like this)

![Desktop of XDO Pico PC](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-win10-04.jpg)

(checking About this PC, and storage size)

![About this pc and storage size](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-win10-05.jpg)

(all this windows 10 booting took 16 minutes.)

(and Excel is preinstalled, I tried to run but it's not working. also I don't need excel.)

![Excel is preinstalled, but I guess trial maybe?](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-excel-01.jpg)

Next step is to wipeout windows 10 and install ubuntu

## Setting up Ubuntu

Purge all the storage and install ubuntu

![Purge all the storage and install ubuntu](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-ubuntu-install-01.jpg)

(installing is in progress)

![installing is in progress](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-ubuntu-install-02.jpg)

(installing ubuntu is much easier than on-boarding windows 10)

## Final Ubuntu

Initial setup for new ubuntu system.

  - install updates
  - set `Natural scrolling` for mouse
  - install `ibus-hangul`(normally I should install it manually, but today, it was already installed), set `Ctrl+Space` as toggle key.
  - launch firefox and install `chrome`

Finally play youtube video, and check some `top` status.

![watch youtube](https://image.dgkim.net/thumbnail/375/2023-pico-pc/pico-pc-ubuntu-done-01.jpg)


## Troubles encountered.

  - Power plug type
    - packaged with `US` plug. not a big problem, I can easily buy `US to KR adapter` (it cost me 1,500 KRW)
  - Can it be powered by USB Power supply?
    - ~~pico pc is powered by USB-C connector, and power requirement is 12V and 2A.~~
    - ~~I don't know USB-A to USB-C will work or not. (I recently bought 8 port QC3.0 compatable USB power supply)~~
    - ~~or, USB-C to USB-C will work?~~
    - It doesn't support USB PD.
  - Audio via 3.5 mm jack is not working.
    - HDMI audio is working without any trouble.
    - I finally fixed by using `alsamixer` (https://superuser.com/questions/1354257/linux-ubuntu-alsa-issues-after-reboot-sound-is-turned-off)
  - The CPU FAN seems run in Full speed always.
    - the fan sound is very(?) noisy. (before I was using Raspberry Pi 4 without FAN, modern laptop's are also quiet on low usage)
    - FAN speed cannot be controlled.
