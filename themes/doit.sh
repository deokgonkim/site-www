#!/bin/bash

mkdir doit

curl -L https://github.com/HEIGE-PCloud/DoIt/archive/refs/tags/v0.4.0.tar.gz \
| tar -xz -C doit/ --strip-components=1

# patch to use custom.html
file="doit/layouts/_default/baseof.html"
line_to_add='  {{ partial "head/custom" . }}'
line_number=17

# Use ed to add the line at the specified line number
ed -s "$file" <<EOF
${line_number}i
$line_to_add
.
w
q
EOF
