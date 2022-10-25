---
# Title of your post. If not set, filename will be used.
title: "Horde Translation"
date: 2014-07-09T09:00:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Open Source"
  - "horde"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

# Horde translation

## How to translate horde project

`horde` provides `horde-translation` command.

```bash
horde-translation \
-b ./ \
update \
-m horde \
-l ko 

horde-translation \
-b ./ \
make \
-m horde \
-l ko

# *.po 파일의 갱신일자 확인할 것
```

## Horde Project sub-projects

```
horde
ingo
kronolith
nag
mnemo
turba
framework/Core
imp
```
