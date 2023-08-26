---
# Title of your post. If not set, filename will be used.
title: "Esphome PIR Sensor + LED Strip"
date: 2023-08-27T01:41:18+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Open Source"
  - "ESP8266"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

# Story

I wanted to implement automatic LED light, when I approach kitchen.

## Prepare

- ESP8266 compatible board. (I use `ESP01` board this time)
- WS2812B LED Strip (5v addressable LED)
- HC-SR501 PIR Sensor (body detection sensor)

## Wiring

- WS2812B
  - vcc : to USB 5v positive pin
  - gnd : to USB ground pin
  - data : to GPIO1 of `ESP01`

- HC-SR501
  - vcc : to USB 5v positive or 3.3v
  - gnd : to USB ground pin
  - data : to GPIO0 of `ESP01`

## Result

![Overall Photo](https://image.dgkim.net/thumbnail/375/esphome-pir-led/IMG_5308.jpg)

![PCB Soldering](https://image.dgkim.net/thumbnail/375/esphome-pir-led/IMG_5309.jpg)

![Installed on Kitchen](https://image.dgkim.net/thumbnail/375/esphome-pir-led/IMG_5311.jpg)

## ESPHOME

```yaml
esphome:
  name: kitchen

esp8266:
  board: d1_mini

# Enable logging
logger:

# Enable Home Assistant API
api:
  password: ""

ota:
  password: ""

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  # Enable fallback hotspot (captive portal) in case wifi connection fails
  ap:
    ssid: !secret wifi_fb_ssid
    password: !secret wifi_fb_password

captive_portal:
    
# Example configuration entry
light:
  - platform: neopixelbus
    type: GRB
    variant: WS2812
    pin: GPIO1 # ESP01 GPIO1
    num_leds: 17
    name: "Kitchen Light"

binary_sensor:
  - platform: gpio
    pin: 0 # ESP01 GPIO0
    name: "Kitchen PIR Sensor"
    device_class: motion
```

## Home Assistant automation

![Home Assistant automation config](https://image.dgkim.net/esphome-pir-led/homeassistant_automation.png)
