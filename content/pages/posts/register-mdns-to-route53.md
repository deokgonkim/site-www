---
# Title of your post. If not set, filename will be used.
title: "Register mDNS to AWS Route53"
date: 2022-12-19T17:13:04+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "AWS"
  - "mDNS"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

## Register mDNS records to AWS Route53

In local network, I can use mDNS names like `DESKTOP-RHM4944.local`, but I cannot use mDNS name over OpenVPN. I uses openvpn to access office network, and I want to be able to find out client IP of certain PC. and the PC uses DHCP to obtain dynamic IP.

I have AWS environment, so I can use Route32 to resolve local hostname.

## The network

- AWS VPC
- EC2 with OpenVPN Server
- RaspberryPi on Office network (connected to OpenVPN Server)
- Client Laptop (as Remote Worker)

## AWS Route53 Private Zone

- Create `Route53` Private Zone to be used as `.local` alternative. I will connect `DESKTOP-RHM4944.office` instead of `DESKTOP-RHM4944.local`

## Setup Site-to-site VPN using AWS EC2 OpenVPN server and OpenVPN Client on RPi

(I will not describe here, I have done it before)

## Setup RPi to update Route53 record.

- Install `avahi-utils` package to resolve local hostname to IP address
  ```bash
  sudo apt install avahi-utils
  ```

- Install and configure `AWS CLI` : I will not discuss here

- `~/bin/avahi-resolve.sh` : to get IP address using mDNS name
  ```bash
  #!/bin/bash

  avahi-resolve --name $1
  ```

- `~/bin/list-zone.sh` : to get Route53 record list
  ```bash
  #!/bin/bash

  HOSTED_ZONE_ID="" # fill in your hosted zone ID

  aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID > ~/list.json
  ```

- `~/bin/prepare-update-record.py` : to prepare payload to be used as Route53
  ```python
  #!/usr/bin/python3

  import json
  import os
  import subprocess

  suffix = '.office.'

  def main():
      changes = []
      hosts = []
      with open(os.path.expanduser('~/list.json'), 'r') as f:
          content = f.read()
          records = json.loads(content)
          host_only = [ item for item in records.get('ResourceRecordSets') if item.get('Type') == 'A' ]
          for host in host_only:
              hostname = host.get('Name')
              ip = None
              try:
                  ip = host.get('ResourceRecords')[0].get('Value')
              except Exception as e:
                  print('Exception while getting IP')
                  print(e)
              hostname_without_suffix = hostname.replace(suffix, '')
              output = subprocess.check_output([os.path.expanduser('~/bin/avahi-resolve.sh'), hostname_without_suffix + '.local'])
              if len(output) > 0:
                  line = output.decode('utf-8').strip()
                  try:
                      local_hostname, current_ip = line.split('\t')
                      if ip != current_ip:
                          print(f'Replacing {hostname} with {current_ip}. was {ip}')
                          changes.append({
                              'Action': 'UPSERT',
                              'ResourceRecordSet': {
                                  'Name': hostname,
                                  'Type': 'A',
                                  'TTL': 30,
                                  'ResourceRecords': [{
                                      'Value': current_ip
                                  }]
                              }
                          })
                      else:
                          print(f'Not updating {hostname}')
                      hosts.append({
                          'Hostname': hostname,
                          'LocalHostname': local_hostname,
                          'CurrentIP': current_ip
                      })
                  except Exception as e:
                      print(e)
              else:
                  print(f'Host {hostname} not found')

      payload = {
          "Changes": changes
      }
      with open(os.path.expanduser('~/change-batch.json'), 'w') as f:
          f.write(json.dumps(payload, indent=4))
      with open(os.path.expanduser('~/hosts.json'), 'w') as f:
          f.write(json.dumps(hosts, indent=4))


  if __name__ == '__main__':
      main()
  ```

- `~/bin/update-route53-records.sh`
  ```bash
  #!/bin/bash

  HOSTED_ZONE_ID="" # fill in your hosted zone ID

  aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://~/change-batch.json
  ```

- `crontab -e`
  ```
  * * * * * /home/pi/bin/list-zone.sh && /home/pi/bin/prepare-update-record.py && /home/pi/bin/update-route53-records.sh
  ```
