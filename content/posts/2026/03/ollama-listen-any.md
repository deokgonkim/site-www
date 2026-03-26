---
# Title of your post. If not set, filename will be used.
title: "Make Ollama to Listen Any"
date: 2026-03-26T15:30:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - AI
---

Make `ollama` to listen on `0.0.0.0` instead of `127.0.0.1`(*default*)

So that other hosts can talk to `ollama`

I installed `ollama` on `lxc` container, so I need to make my host machine or other container can use `ollama` running on the other container.
<!--more-->

## On Linux
### Edit ollama service

```bash
sudo systemctl edit ollama.service
```

- Add following
```
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
```

### Reload

```bash
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

## On mac OS

```bash
launchctl setenv OLLAMA_HOST "0.0.0.0:11434"
```

