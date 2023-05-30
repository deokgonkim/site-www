---
# Title of your post. If not set, filename will be used.
title: "Show Applications installed on User's own home directory"
date: 2023-05-30T14:30:24+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "linux"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

## Showing User's application in `Show all applications`

On ubuntu, when you press `Super` key twice or press `Super+A`, you see applications installed on host.
But, not all applications are installed via `dpkg` or `snap`. for example, Postman and Bitwarden doesn't provide installers instead they provides something like App Image.

I place such programs in `~/Applications`. and I want to run this kind of program conviniently using `Super` key like `Spotlight search` in Mac.

This can be done by creating `.desktop` file in `~/.local/share/applications`

  - `Postman.desktop` example
  ```
  #!/usr/bin/env xdg-open
  [Desktop Entry]
  Name=Postman
  Type=Application
  Exec=/home/dgkim/Applications/Postman/Postman
  ```

## Reference

- https://askubuntu.com/questions/1351795/create-launcher-for-application-not-in-usr-share-applications-in-ubuntu-20-04
