---
# Title of your post. If not set, filename will be used.
title: "2023 Esp8266 Ir Remote"
date: 2023-11-15T06:00:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - esp8266

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

## ESP8266 + IR Receiver + IR Transmitter

When I was using raspberry pi, I bought a IR transceiver module for Arduino. and used it for several years. [IR transceiver](/pages/posts/telegram-bot-try2/)

![Raspberyr Pi, IR Transceiver and DHT11](/uploads/2019-may-iot-project/Photo-2019-05-31-00-05-52_0448-1.jpg)

And this year, I am interested in ESP8266, so I bought another IR receiver, IR transmitter.

## Installed.

Install esp8266 and voltage converter on breadboard.

![esp8266, breadboard, and ir receiver](https://image.dgkim.net/thumbnail/375/2023-esp8266-ir-remote/IMG_5620.jpg)

Install IR receiver and IR transmitter in front of tv

![ir receiver, ir transmitter](https://image.dgkim.net/thumbnail/375/2023-esp8266-ir-remote/IMG_5623.jpg)

Install breadboard below of table

![Installed breadboard](https://image.dgkim.net/thumbnail/375/2023-esp8266-ir-remote/IMG_5624.jpg)

And here is [ESPHome Source](https://github.com/deokgonkim/example/blob/main/esphome/livingroom4/livingroom4.yml)

## Further more

I orignally, wanted to install these.

![protoboard, esp8266, voltage converter, ir receiver, ir transmitter](https://image.dgkim.net/thumbnail/375/2023-esp8266-ir-remote/IMG_5591.jpg)

![protoboard, esp8266, voltage converter, ir receiver, ir transmitter](https://image.dgkim.net/thumbnail/375/2023-esp8266-ir-remote/IMG_5592.jpg)

ESP01 is very interesting, but, providing both 3.3v and 5v is somewhat overwhelming?
