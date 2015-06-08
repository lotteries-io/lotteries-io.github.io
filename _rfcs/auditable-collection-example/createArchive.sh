#!/bin/bash

function sha256UrlSafe  {
  # $1 | tr '+' '-' | tr '/' '_'
  echo $(openssl dgst -sha256 -binary $1 | base64 -w 0 | tr '+' '-' | tr '/' '_')
}

#
# for both orders, create a directory that is the url safe sha256
#
for order in $(ls order*.json); do
  orderSha=`sha256UrlSafe $order`
  echo $orderSha
  if [ -d "$orderSha" ]; then
    rm -rf $orderSha
  fi
  mkdir $orderSha
  cp $order $orderSha/order.json
done
