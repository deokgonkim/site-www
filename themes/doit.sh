#!/bin/bash

mkdir doit

curl -L https://github.com/HEIGE-PCloud/DoIt/archive/refs/tags/v0.4.0.tar.gz \
| tar -xz -C doit/ --strip-components=1
