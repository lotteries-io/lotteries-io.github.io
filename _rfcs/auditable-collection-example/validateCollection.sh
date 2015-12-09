#!/bin/bash
function before {
  #
  # clean up any left over working directory
  #
  if [ -d validation ]; then
    echo "cleaning validation directory"
    rm -rf validation
  fi
  mkdir validation
}

function sha256UrlSafe  {
  # $1 | tr '+' '-' | tr '/' '_'
  echo $(openssl dgst -sha256 -binary $1 | base64 | tr '+' '-' | tr '/' '_')
}

function compareOrderWithHashInDirectory {
  # compute hash of order.json and see if matches the directory hash...
  orderSha=$(sha256UrlSafe validation/downloadable-collection/$1/order.json)
  if [ $orderSha = $1 ]
    then
      echo "order hash matches directory name... OK"
    else
      echo "order hash does not match directory name... INVALID"
  fi
}

function checkRetailerSignature {
  # check signature in order.signature and check order using retailer certificate
  jq '.signature' -r validation/downloadable-collection/$1/order.signature | base64 --decode > validation/downloadable-collection/$1/order.signature.raw
  openssl dgst -sha256 \
    -verify retailer/retailer-public_key.pem \
    -signature validation/downloadable-collection/$1/order.signature.raw \
    validation/downloadable-collection/$1/order.json
  echo "validated retailer signature..."
}

function checkOrderResult {
  # extract the hash in the order.result document and compare it to the actual order
  ORDER_RESULT_HASH=$(jq -r '."order-digest"' validation/downloadable-collection/$1/order.result | cut -d : -f 2)

  if [ $ORDER_RESULT_HASH = $1 ]; then
    echo "order-digest in result matches order... OK."
  else
    echo "order-digest in result ($ORDER_RESULT_HASH) does not match order... INVALID"
    return 2
  fi

  # check processing-state is "accepted"
  ORDER_RESULT_STATUS=$(jq -r '."order-processing-result"' validation/downloadable-collection/$1/order.result)
  if [ $ORDER_RESULT_STATUS = "accepted" ]; then
    echo "order is accepted... OK"
  else
    echo "order is $ORDER_RESULT_STATUS... INVALID"
    return 3
  fi
}

function checkOperatorSignature {
  # extract signature from order.result.signature
  jq '.signature' -r validation/downloadable-collection/$1/order.result.signature | base64 --decode > validation/downloadable-collection/$1/order.result.signature.raw
  openssl dgst -sha256 \
    -verify operator/operator-public_key.pem \
    -signature validation/downloadable-collection/$1/order.result.signature.raw \
    validation/downloadable-collection/$1/order.result
  echo "validated operator signature... OK"
}

function checkTimestamp {
  cat validation/downloadable-collection/$1/order.result.signature.timestamp | base64 --decode > validation/downloadable-collection/$1/order.result.signature.timestamp.raw

  echo "extracted timestamp"

  openssl ts -verify \
    -data validation/downloadable-collection/$1/order.result.signature.raw \
    -CAfile ca/certs/ca-cert.pem \
    -in validation/downloadable-collection/$1/order.result.signature.timestamp.raw
  echo "validated timestamp... OK"
}

set -e
before
cp downloadable-collection.zip validation
unzip validation/downloadable-collection.zip -d validation

for order in $(ls validation/downloadable-collection); do
  echo "validating $order"
  compareOrderWithHashInDirectory $order
  checkRetailerSignature $order
  checkOrderResult $order
  checkOperatorSignature $order
  checkTimestamp $order
done

echo "all OK"
