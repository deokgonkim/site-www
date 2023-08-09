---
# Title of your post. If not set, filename will be used.
title: "Esphome Relay Fan"
date: 2023-08-10T07:01:14+09:00
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

# ESPHOME + Relay + FAN

![Overall Photo](https://image.dgkim.net/thumbnail/375/esphome-relay-fan/esp8266-relay-fan.jpeg)

## ESP8266 PCB

![ESP8266 PCB](https://image.dgkim.net/esphome-relay-fan/esp8266-pcb.png)

## ESPHOME

```yaml
esphome:
  name: six

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
switch:
  - platform: gpio
    pin: GPIO4
    name: "Switch2"
    inverted: true
  - platform: gpio
    pin: GPIO5
    name: "Switch3"
    inverted: true
  - platform: gpio
    pin: GPIO12
    name: "Switch4"
    inverted: true
  - platform: gpio
    pin: GPIO13
    name: "Switch5"
    inverted: true
  - platform: gpio
    pin: GPIO14
    name: "Switch6"
    inverted: true
```

## Home Assistant automation

- Turn on when RPi4's temperature is above 58

```yaml
alias: rpi4-cooling
description: ""
trigger:
  - platform: numeric_state
    entity_id: sensor.rpi4_temperature
    above: 58
condition: []
action:
  - type: turn_on
    device_id: 98f3c834a50732c3b8981d0d5925158a
    entity_id: 186a943f4f7f486e95ce2bb1c6751a7f
    domain: switch
mode: single
```

- Turn off when RPi4's temperature is below 50

```yaml
alias: rpi4-cooling-stop
description: ""
trigger:
  - platform: numeric_state
    entity_id: sensor.rpi4_temperature
    below: 50
condition: []
action:
  - type: turn_off
    device_id: 98f3c834a50732c3b8981d0d5925158a
    entity_id: 186a943f4f7f486e95ce2bb1c6751a7f
    domain: switch
mode: single
```
