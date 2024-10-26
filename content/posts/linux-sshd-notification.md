---
# Title of your post. If not set, filename will be used.
title: "Linux Sshd Notification"
date: 2022-08-09T05:30:47+09:00
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

For security reasons, I created a script to notify me when someone(**ME**) access my server.

I created `slack` notification script, I will not explain about *how to create slackbot* here. You can have a good time to configuring slack bot.

# /etc/pam.d/sshd

Append follow line to `/etc/pam.d/sshd`

```
session required pam_exec.so /etc/pam.scripts/noti_slack.sh
```

# /etc/pam.scripts/noti_slack.sh

Create `/etc/pam.scripts/noti_slack.sh` file. and make the file executable `chmod +x /etc/pam.scripts/noti_slack.sh`

```bash
#!/bin/bash

SLACK_URL=https://slack.com/api/chat.postMessage

# Slack bot BOT_NAME's token
# https://api.slack.com/apps/SOMAPPIDHEX/
SLACK_TOKEN="xoxb-nnnnnnnnnn-nnnnnnnnnnnnn-SomeAlphaNumeric1234Code"
SLACK_CHANNEL=general


PAYLOAD=$(echo "
{
    \"channel\": \"$SLACK_CHANNEL\",
    \"text\": \"${PAM_USER} is trying to access ssh on ${HOSTNAME}\n
A SSH login was successful, so here are some information for security:\n
User:        $PAM_USER\n
User IP Host: $PAM_RHOST\n
Service:     $PAM_SERVICE\n
TTY:         $PAM_TTY\n
Date:        `date`\n
Server:      `uname -a`\"
}
" | tr '\n' ' ')

if [ "x${PAM_TYPE}" = "xopen_session" ]; then
	curl -H "Content-Type: application/json" -H "Authorization: Bearer ${SLACK_TOKEN}" -X POST $SLACK_URL -d"$PAYLOAD"
fi

exit 0
```