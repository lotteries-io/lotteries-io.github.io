#!/bin/bash


function sha256Base64  {
  # $1 | tr '+' '-' | tr '/' '_'
  echo $(openssl dgst -sha256 -binary $1 | base64 -w 0)
}

function sha256UrlSafe  {
  # $1 | tr '+' '-' | tr '/' '_'
  echo $(openssl dgst -sha256 -binary $1 | base64 | tr '+' '-' | tr '/' '_')
}

#
# creates order subdirectory and copies in raw-order as order.json
#
function createOrderSubdirectoryWithOrder {
  mkdir downloadable-collection/$1
  cp $2 downloadable-collection/$1/order.json
}

#
# Given our global timing variables, fill in the template, write it to a tmp file
#
function createOrderFromTemplate {
  source $1
  baseName=$(basename `pwd`/raw-orders/$1 .sh)
  orderFile=raw-orders/$baseName.json
  echo $ORDER > $orderFile
}


#
# computes retailer signature over raw order bytes
#
function writeRetailerSignature {
  RETAILER_SIG_BASE64=$(openssl dgst -sha256 -binary -sign retailer/retailer-private_key.pem downloadable-collection/$1/order.json | base64)

  RETAILER_SIGN_JSON=$(cat <<EOF
{
  "algorithm": "rsa-sha256",
  "keyId": "retailer1",
  "signature": "$RETAILER_SIG_BASE64"
}
EOF
)
  echo $RETAILER_SIGN_JSON > downloadable-collection/$1/order.signature
}

#
# writes operator acceptance document for order
#
function writeOperatorAcceptance {
  RETAILER_ORDER_REFERENCE=$(jq '.metadata."retailer-order-reference"' -r downloadable-collection/$1/order.json)
  ORDER_ACCEPTANCE=$(cat <<EOF
{
  "order-digest": "sha256:$1",
  "retailer-order-reference": "$RETAILER_ORDER_REFERENCE",
  "retailer": {
    "href": "http://www.operator.com/entities/retailer"
  },
  "order-processing-result": "accepted"
}
EOF
)
  echo $ORDER_ACCEPTANCE > downloadable-collection/$1/order.result
}

#
# operator signs the order.result acceptance document
#
function writeOperatorSignature {
  OPERATOR_SIG_BASE64=$(openssl dgst -sha256 -binary -sign operator/operator-private_key.pem downloadable-collection/$1/order.result | base64)

  OPERATOR_SIGN_JSON=$(cat <<EOF
{
  "algorithm": "rsa-sha256",
  "keyId": "operator1",
  "signature": "$OPERATOR_SIG_BASE64"
}
EOF
)
  echo $OPERATOR_SIGN_JSON > downloadable-collection/$1/order.result.signature
}

function timestampOperatorSignature {
  RAW_OPERATOR_SIG=$(jq '.signature' -r downloadable-collection/$1/order.result.signature | base64 --decode)
  echo $RAW_OPERATOR_SIG | openssl ts -query -sha256 -cert -out downloadable-collection/$1/operator.signature.tsq
  openssl ts -config openssl.cnf -reply \
    -queryfile downloadable-collection/$1/operator.signature.tsq \
    -signer tsa/tsa-cert.pem \
    -inkey tsa/tsa-private_key.pem \
    -chain ca/certs/ca-cert.pem \
    | base64 > downloadable-collection/$1/order.result.signature.timestamp

  rm downloadable-collection/$1/operator.signature.tsq
}

function before {
  #
  # clean up any left over downloadable-collection
  #
  if [ -d downloadable-collection ]; then
    echo "removing existing downloadable-collection in $(pwd)/downloadable-collection"
    rm -rf downloadable-collection
  fi
  mkdir downloadable-collection

  #
  # clean up any template output from raw-orders
  #
  rm -rf raw-orders/*.json
}

#
# set timezone in the shell to UTC,
# remember the original one
#
TZ_ORIG=$TZ
TZ="/usr/share/zoneinfo/UTC"
export TZ

# timings for use in the order "templates"
NOW=$(date +%Y-%m-%dT%H:%M:%SZ)
IN_TWO_DAYS=$(date -v "+2d" +%Y-%m-%d)
IN_THREE_DAYS=$(date -v "+3d" +%Y-%m-%d)


before

for order in $(ls raw-orders/*.sh); do
  createOrderFromTemplate $order
  orderSha=`sha256UrlSafe $orderFile`
  createOrderSubdirectoryWithOrder $orderSha $orderFile
  writeRetailerSignature $orderSha
  writeOperatorAcceptance $orderSha
  writeOperatorSignature $orderSha
  timestampOperatorSignature $orderSha
done

# create a zip of downloadable-collection
zip -r  downloadable-collection.zip downloadable-collection/

export TZ=$TZ_ORIG
