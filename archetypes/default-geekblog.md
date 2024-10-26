---
# Title of your post. If not set, filename will be used.
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true

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

