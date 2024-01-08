---
# Title of your post. If not set, filename will be used.
title: "2019 May IoT project"
date: 2019-05-29T22:31:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Raspberry Pi"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

As I previously posted, I made a WiFi AC remote controller project. see [telegram bot for HVAC](/pages/posts/telegram-bot-try2)

Today, I begin a new project to go further.

I purchased another Raspberry Pi 3 Model B, AND Raspberry Pi Sensor Kit. (http://m.eleparts.co.kr/goods/view?no=3730500 and http://m.eleparts.co.kr/goods/view?no=3030452)

(I just wanted to purchase sensor only, but I can't sure, I could attach these sensors to my existing RPi, so I posted a question to a forum https://www.cooking-hacks.com/forum/viewtopic.php?f=43&t=19434&sid=d89e064868d4a0dce0c58ea7a6490bde)

And, I tested DHT11 as https://github.com/deokgonkim/rpi_sensor

&nbsp;

My next step will be,

1. set up a messaging queue, like Rabbit MQ

2. set up a web/api server for gathering the data and the controll center.

3. my existing bot code shoud be migrated to a new server, and these two RPi should listen to MQ for commands, and should send data to MQ.

&nbsp;

To be continued...

<!--more-->

2019/05/29

https://www.rabbitmq.com/tutorials/tutorial-one-python.html

yum install rabbitmq-server

pip install pika

https://github.com/deokgonkim/rpi_sensor/commit/dc95b7408ff36fca38d0cc3044760f6c5d9b5967

https://github.com/deokgonkim/lirc-telegram-bot/commit/30d019286a8e30f3f7d9f31804d7c402b4e09f7e

&nbsp;

2019/05/30

https://www.cooking-hacks.com/forum/viewtopic.php?f=43&t=19434&sid=b35e377ce464afdb35b206048f90ee3d

Ok, I guess I can do, (first, I need to know the pin)

https://www.cooking-hacks.com/documentation/tutorials/raspberry-pi-to-arduino-shields-connection-bridge/

And It works,

![Raspberyr Pi, IR Transceiver and DHT11](/uploads/2019-may-iot-project/Photo-2019-05-31-00-05-52_0448-1.jpg)

And the codes,

https://github.com/deokgonkim/rpi_sensor/commit/763ba06985067a11f95ae087e8ac224c8b49e86d

To be continued.

&nbsp;

2019/06/02

I switched MQ from direct queue to fanout-exchange.

I defined protocol, for extensible.

I prepared persistent storage. RDB.

so the code. https://github.com/deokgonkim/dgkimnet-homeserver/commit/cc46a6b67904dd8a54466b30499119748dbf3304

To be continued...

&nbsp;

2019/06/03

Just, server project, progress. one milli-codes?

https://github.com/deokgonkim/dgkimnet-homeserver/commit/1b6b13d06214422393dfad2cd32baaffa93b4990

&nbsp;

2019/06/15

Finally, the original idea has completely implemented.

https://github.com/deokgonkim/dgkimnet-homeserver/commits/master
