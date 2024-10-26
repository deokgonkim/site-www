---
# Title of your post. If not set, filename will be used.
title: "Twitter Espeak"
date: 2022-08-12T12:22:51+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Open Source"
  - "linux"

# Set how many table of contents levels to be showed on page.
# geekblogToC: 3

# Add an anchor link to headlines.
# geekblogAnchor: true
---

What if my `tweets` can be heard

# Install rainbowstream

rainbowstream is a twitter client for linux cli.

- prepare python `venv`
```bash
python3 -m venv venv
source venv/bin/activate
```

- install rainbowstream
```bash
pip install rainbowstream
```

- run rainbowstream
```
rainbowstream
# you will be asked to login to twitter
```

# Install espeak

espeak is TTS software for linux

```bash
sudo apt install espeak
```

test espeak can speak

```bash
espeak hello
espeak "한글"
echo "hello" | espeak
```

# Prepare text stream

I will create temporary PIPE file that will pass the texts from `rainbowstream` to `espeak`

```bash
mkfifo /tmp/sock
```

# Run read and speaker

espeak will listen on /tmp/sock for text

```bash
#!/bin/bash

test -e /tmp/rainbowsream || mkfifo /tmp/rainbowstream

while true
do
espeak < /tmp/rainbowstream
done
```

# Run rainbowstream and feed texts

run rainbowstream in text only mode

```bash
rainbowstream | sed -u -e 's/\x1b\[[0-9;]*m//g' | tee /tmp/sock
```

- `sed` will remove color code
- `tee` will pass text to the PIPE and will print out too
- you can remove additional unnecessary text via `sed` or `grep`. I uses `grep --line-buffered -v "id:[0-9]+ via"`
