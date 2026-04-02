---
# Title of your post. If not set, filename will be used.
title: "Compare Cloud Storage"
date: 2026-04-02T10:00:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "CloudStorage"
  - ownCloud
---

My journey to cloud storage.  
I have used `ownCloud` for decades. It was running on AWS EC2 Ubuntu 16.04 for years.  
But I recently upgraded my EC2 to `Ubuntu 24.04` and then `ownCloud` stopped working.

So I need to change my cloud storage service.

There are big major players like `Google Drive`, `Apple iCloud` and etc.

These two has critical problems for me.

- `Google Drive`: When using on Linux, It is slow, and `mount` is not completely implemented in shell environment(showing arbitrary alphanumeric names not actual filename)
- `Apple iCloud`: I use Mac, but I use Linux 95% of my life. I don't think iCloud client works perfectly on linux.

## Current Status

I have installed and testing `S3Drive` and it disappointed me.  
So, I want another solution. The software list below is provided by `ChatGPT`  
I thoroughly visited the web site, and checked for my requirements.

## TLDR

- [ownCloud](#owncloud) *Old PHP issue*
- [NextCloud](#nextcloud) *Too big for me*
- [S3Drive](#s3drive) *Performance issue*
- [Dropbox](#dropbox)
- [pCloud](#pcloud) *AppImage installation*, *mount type is primary*
- [sync.com](#synccom) *No linux Client*
- [mega](#mega) *VPN and other apps*
- [koofr](#koofr) *targz installation*
- [icedrive](#icedrive) *mount*
- [tresorit](#tresorit) *sh installation*
- [Internxt](#internxt) *VPN and other apps* *only Annual payment*
---
- [rclone](#rclone) *Tried. unreliable*
- [seafile](#seafile) *Community Edition vs Professional Edition*
- [insync](#insync) *One-time payment*
- [Mountain Duck](#mountainduck) *No linux Client*

---

### ownCloud
- https://owncloud.com/
- Free, Self-hosting
- **Doesn's support PHP 8.3**
- ownCloud Server 10.16 Requirements
  - Ubuntu 20.04 LTS
  - MariaDB 10.11
  - PHP 7.4

### NextCloud
- https://nextcloud.com/
- Free, Self-hosting
- Can be installed using `docker`
  - **But requires minimum 2GB of memory**: I want to run on AWS EC2 t3.micro or smaller.

### S3Drive
- https://s3drive.app/
- Subscription: 1.99 EUR / month
  - Storage is not include. so I can use **AWS S3** (**Reliable!** my favorite for storing files)
	- Subscription fee is only for `software` itself. (and the feature what I need is `Two-way` sync)
- Cons.
  1. Timestamp on local files are scrambled.
  2. CPU Spiking when synchronizing, and the App is unresponsive. (App is not trustworthy for me)
  3. There is not logs for conflicts. (also no log entry for generic file sync)
  4. Uses excessive memory. up to 2.5GB, 3GB and even more. (Memory is eventually released after synchronization.) [^memory-note]

### Dropbox
- https://www.dropbox.com/
- Subscription: 9.99 USD / month (billed annually) 11.99 USD / month (billed monthly)
  - `Plus`: For 1 person, 2TB Storage
  - `Professional`: For 1 person, 3TB Storage
  - `Standard`: 15 USD/user/month, 5TB Storage per team (minimum 3 user)
  - `Advanced`: 24 USD/user/month, 15TB Storage per team (minimum 3 user)

### pCloud
- https://www.pcloud.com/ 2013 Switzerland
- Subscription: 4.99 USD / month
  - Family Plan provided (up to 5 user) LIFETIME 595 USD
- Linux
  - `AppImage` (**not my favorite**)

### ~~sync.com~~
- https://www.sync.com/ 2011 Canada
- **No Linux Client**

### mega
- https://mega.io/ 2013 New Zealand
- Not only a Cloud Storage provider, but also provides vpn, object storage, password manager, chat and meeting.
- I do want **only storage** provider. not vpn.

### koofr
- https://koofr.eu/ 2013 Slovenia
- Subscription: 4~10 EUR / month
  - `Suitcase`
    - `250GB`: 4 EUR / month
    - `500GB`: 7 EUR / month
    - `1TB`: 10 EUR / month
- Linux
  - `targz` : with `install.sh`

### icedrive
- https://icedrive.net/ 2019 UK
- Subscription: 5.99 USD / month
  - `PRO` : 2TB
- Linux
  - CLI, `AppImage`(**not my favorite**)
- `mount` not `synchronization` (**I want synchronization with my local disk**)

### tresorit
- https://tresorit.com/ 2011 Hungary
- Linux
  - Installation via `sh`: `trasorit_installer.run` (not my favorite)

### Internxt
- https://internxt.com/ 2020 Spain
- Subscription: 24 EUR / year
  - `Essential`: 1TB
- Linux : `deb`
- Not only Cloud Storage provider, but also provides vpn, antivirus, cleaner, meet services.
- I do want **only storage** provider. not vpn.

## Other

### rclone
- OpenSource
- Tried `rclone bisync` with custom wrapper script
  - Takes too much time
  - Custom script may be inconvinient and unreliable

### seafile
- Self-hosting
- **Community Edition vs Professional Edition**

### insync
- **One-time payment 39.99 USD**

### MountainDuck
- **No Linux Client**

## Is there a farely good solution for me?

I am considering to use `Dropbox`  
What I am hasitating is that I have only installed software with `free` plan without storing meaningful files. and I deleted account a month ago.  
So, is it really worth to **re**subscribe paid plan.

## (2026-04-02 update) dropbox first impression

1. Seamless installation failed on one linux machine  
  `libglapi-mesa`: it must be installed, but the installer didn't handle it properly. I manually installed. but after installation, dropbox app still not working.  
  It shows still 'indexing'(using command `dropbox status`). I tried command `dropbox update` and restarted dropbox. It fixed problem.

2. On Mac OS: There was no `Dropbox` folder in **user's home**.
  I found it in `Preferences` and it says it is located at `/Users/dgkim/Library/CloudStorage/Dropbox`.  
  It may or may not cause some problems.

3. On Mac OS: Screen capture auto archiving. It may helpful.

4. On iPhone: like other many iOS apps, the `on boarding process` may be confusing.

5. Synchronization Experience: It seems ok. I leave it open for several devices. and It shows near-real-time synchronization. It seems fine!

6. `dropbox` cli: I first found in Linux os. It must be helpful. **THANK YOU! DROPBOX!** but. the `dropbox` command is not available on Mac OS.

[^memory-note]: All this post is caused by this. This is my critical reason for switching cloud storage
