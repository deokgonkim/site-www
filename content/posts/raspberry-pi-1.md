---
# Title of your post. If not set, filename will be used.
title: "Raspberry Pi 1"
date: 2023-11-02T05:44:09+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Open Source"
  - "Raspberry Pi"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

## My Raspberry Pi 1

- Bought : ₩58,000 2013/04/24
  - with : PiFace, BOARD, I/O EXPANSION, RASPBERRY-PI (₩48,570)

- At First : install raspbian. tested relay, and tested led on PiFace

- As a IR Remote controller : [telegram-bot-try2](/pages/posts/telegram-bot-try2/), [2019 May IoT project](/pages/posts/2019-may-iot-project/)

- As a Thermal sensor : finally just read DHT11 temperature/humidity and send it to the server.
  
  ```bash
  #!/bin/bash

  export API_URL=https://public-api.dgkim.net
  export API_KEY=----

  export DHT11=/home/pi/git/rpi_sensor/src/test_dht11

  export HUMI_TEMP=$($DHT11 | tail -1)

  HUMI=$(echo $HUMI_TEMP | tr "," "\n" | head -1)
  TEMP=$(echo $HUMI_TEMP | tr "," "\n" | tail -1)

  TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S%z")

  echo "HUMI $HUMI"
  echo "TEMP $TEMP"


  curl -X POST "$API_URL/v1/temperatures/" \
  -H 'Content-Type: application/json' \
  -H "X-API-KEY: $API_KEY" \
  -d"
  {
    \"temperature\": $TEMP
  }
  "
  ```

- Today : Turn it off.. and remove SD Card from it. Please Rest in Peace my raspberry pi.

ps. currently My Raspberry Pi3 is running as home assistant server, My Raspberry Pi4 is running as home server and youtube machine.
