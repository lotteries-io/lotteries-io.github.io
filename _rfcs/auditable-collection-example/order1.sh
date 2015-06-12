#!/bin/bash

function sha256Base64  {
  # $1 | tr '+' '-' | tr '/' '_'
  echo $(openssl dgst -sha256 -binary $1 | base64 -w 0)
}

#
# set timezone in the shell to UTC,
# remember the original one
#
TZ_ORIG=$TZ
TZ="/usr/share/zoneinfo/UTC"
export TZ

NOW=$(date +%Y-%m-%dT%H:%M:%SZ)
IN_TWO_DAYS=$(date -d "+2 days" +%Y-%m-%d)
IN_THREE_DAYS=$(date -d "+3 days" +%Y-%m-%d)

ORDER=$(cat <<EOF
{
  "metadata": {
    "retailer": {
      "href": "http://www.operator.com/entities/retailer.com"
    },
    "retail-customer": "47890",
    "retailer-order-reference": "1234567",
    "creation-date": "${NOW}"
  },
  "gaming-product-orders": {
    "http://www.operator.com/gaming-products/foo": {
    	"bets": [
      	{
          "cats": [1, 2, 3, 4, 5],
          "dogs": [1, 8]
        },
        {
          "cats": [2, 4, 6, 29, 32],
          "dogs": [4, 5]
        },
        {
          "cats": [6, 9, 11, 34, 56],
          "dogs": [3, 4]
        }
      ],
      "participation-pools": {
        "first-draw": "${IN_TWO_DAYS}",
        "draw-count": 8
      }
   },
   "http://www.operator.com/gaming-products/bar": {
     "bets": [
       {
         "drinks": [1, 4, 6, 88]
       }
     ],
     "participation-pools": {
       "cycles": ["AM", "PM"],
       "first-draw": "${IN_THREE_DAYS}",
       "draw-count": 20
     }
   }
  }

}
EOF
)

echo $ORDER > order.tmp	
	
#
# compute sha256 of the order in "normal" base64
#
BASE64_SHA256=`sha256Base64 order.tmp`

#
# url safe version of the base64 encoded sha256 hash
#
BASE64_SHA256_URL_SAFE=$(echo $BASE64_SHA256 | tr '+' '-' | tr '/' '_')

#
# place order in the correct target directory
#

if [ ! -e orders ]; then
  mkdir orders	
fi
mkdir orders/$BASE64_SHA256_URL_SAFE
if [ -e retailer-order1.json ]; then
  rm retailer-order1.json
fi
mv order.tmp orders/$BASE64_SHA256_URL_SAFE/order.json




#
# compute retailer signature over the order
#
RETAILER_SIG_BASE64=$(openssl dgst -sha256 -binary -sign retailer/retailer-private_key.pem orders/$BASE64_SHA256_URL_SAFE/order.json | base64 -w 0)
echo "algorithm=rsa-sha256" > orders/$BASE64_SHA256_URL_SAFE/order.signature
echo "keyId=retailer1" >> orders/$BASE64_SHA256_URL_SAFE/order.signature
echo "signature=$RETAILER_SIG_BASE64" >> orders/$BASE64_SHA256_URL_SAFE/order.signature

#
# draw up acceptance document by the operator
#
ORDER_ACCEPTANCE=$(cat <<EOF
{
  "order-digest": "sha256:$BASE64_SHA256",
  "retailer-order-reference": "1234567",
  "retailer": {
    "href": "http://www.operator.com/entities/retailer"
  },
  "order-processing-result": "accepted",
  "nominal-price": {
    "http://www.operator.com/gaming-products/foo": {
      "currency": "EUR",
      "amount": "12.50"
    },
    "http://www.operator.com/gaming-products/bar": {
       "currency": "EUR",
       "amount": "100.00"
    },
    "processing-fee": {
      "currency": "EUR",
      "amount": "1.00"
    }
  }
}
EOF
)
echo $ORDER_ACCEPTANCE > orders/$BASE64_SHA256_URL_SAFE/order.result
	
#
# sign the operator acceptance document
#
OPERATOR_SIG_BASE64=$(openssl dgst -sha256 -binary -sign operator/operator-private_key.pem orders/$BASE64_SHA256_URL_SAFE/order.result | base64 -w 0)
echo "algorithm=rsa-sha256" > orders/$BASE64_SHA256_URL_SAFE/order.result.signature
echo "keyId=operator1" >> orders/$BASE64_SHA256_URL_SAFE/order.result.signature
echo "signature=$OPERATOR_SIG_BASE64" >> orders/$BASE64_SHA256_URL_SAFE/order.result.signature

#
# produce timestamp over the operator signature
#


export TZ=$TZ_ORIG
