#!/bin/bash

mkdir doit

git clone --depth 1 https://github.com/HEIGE-PCloud/DoIt ./doit

# patch to use custom.html
file="doit/layouts/baseof.html"
line_to_add='  {{ partial "head/custom" . }}'
line_number=25

# Use ed to add the line at the specified line number
ed -s "$file" <<EOF
${line_number}i
$line_to_add
.
w
q
EOF

