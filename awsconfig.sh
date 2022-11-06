#!/bin/bash
DIRECTORY="/var/lib/jenkins/.aws"
if [ ! -d "$DIRECTORY" ]; then
mkdir $DIRECTORY
fi
cat > ~/.aws/config <<EOF
[default]
region = us-east-2


EOF

cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id = $1
aws_secret_access_key = $2

EOF