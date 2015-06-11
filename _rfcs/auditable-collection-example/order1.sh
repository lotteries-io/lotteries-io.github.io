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
if [ -e retailer-order1.json ]; then
  rm retailer-order1.json
fi
echo $ORDER > retailer-order1.json

#
# compute sha256 of the order in "normal" base64
#
BASE64_SHA256=`sha256Base64 retailer-order1.json`
echo $BASE64_SHA256

#
# url safe version of the base64 encoded sha256 hash
#
BASE64_SHA256_URL_SAFE=$(echo $BASE64_SHA256 | tr '+' '-' | tr '/' '_')

mkdir orders
mkdir orders/$BASE64_SHA256_URL_SAFE



#
# compute retailer signature over the order
#

#
# draw up acceptance document by the operator
#

#
# sign the operator acceptance document
#

#
# produce timestamp over the operator signature
#


export TZ=$TZ_ORIG
