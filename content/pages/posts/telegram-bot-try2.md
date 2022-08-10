---
# Title of your post. If not set, filename will be used.
title: "telegram bot 제 2탄"
date: 2018-08-15T19:29:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Open Source"
  - "python"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

텔레그램 봇을 만들어 보았었지요.

이번엔 그 두 번째 이야기.

HVAC IR Remote라는 라즈베리파이에 올릴 수 있는 IR Transceiver를 구매하고,
원격에서 집에 있는 장치를 리모콘 조작하듯이 켜고 끌 수 있는 것을 만들어 보았습니다.

Github : https://github.com/deokgonkim/lirc-telegram-bot

<code>
# hvac-telegram-bot

## My Hardware

 * Raspberry Pi Model B. (old one)
 * HVAC IR Remote for arduino / Raspberry Pi
   * https://www.cooking-hacks.com/hvac-ir-remote-shield-for-raspberry-pi
   * https://www.cooking-hacks.com/documentation/tutorials/control-hvac-infrared-devices-from-the-internet-with-ir-remote/

## Setting up HVAC IR Remote for LIRC

 * Instructions

> https://www.hackster.io/austin-stanton/creating-a-raspberry-pi-universal-remote-with-lirc-2fd581

 * Install lirc package

```
sudo apt-get install lirc
```

 * Configure kernel module

```
vi /etc/modules
lirc_dev
lirc_rpi gpio_in_pin=18 gpio_out_pin=23
```
> note I/O port is different than above documentation.
> You can find GPIO port for HVAC IR Remote in arduPi.cpp

```
vi /etc/lirc/hardware.conf
```
> see above document

```
vi /etc/lirc/lirc_options.conf
```
> https://raspberrypi.stackexchange.com/questions/50873/lirc-wont-transmit-irsend-hardware-does-not-support-sending
> set driver to 'default'

 * Record IR signal or obtain configuration file.
> http://lirc.sourceforge.net/remotes/

> My testing board didn't work as expected.
> I can only control IR LED, two buttons, two indication LEDs. but can't read IR signal. I don't know board is broken or something.

## Preparations

following my own blog https://www.dgkim.net/wordpress/2017/08/24/telegram-bot-%ed%85%8c%ec%8a%a4%ed%8a%b8-%eb%85%b8%ed%8a%b8/

### python-telegram-bot
> I tried 
```
git clone https://github.com/python-telegram-bot/python-telegram-bot

cd python-telegram-bot
git submodule update
```

> But, today I changed plan.
> https://pypi.org/project/python-telegram-bot/

## programming part

> I referenced https://github.com/python-telegram-bot/python-telegram-bot/tree/master/examples

> quickly created firstbot.py
</code>
