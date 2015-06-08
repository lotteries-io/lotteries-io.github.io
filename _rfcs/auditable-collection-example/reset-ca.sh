#!/bin/bash

#
# resets the CA (the text db and serial list)
#

if [ -a ca/index.txt ]; then
  rm ca/index.txt
fi
touch ca/index.txt

if [ -a ca/certs/serial ]; then
  rm ca/certs/serial
fi
echo 1000 >> ca/certs/serial
