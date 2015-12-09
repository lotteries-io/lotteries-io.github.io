#!/bin/bash
ORDER=$(cat <<EOF
{
  "metadata": {
    "retailer": {
      "href": "http://www.operator.com/entities/retailer.com"
    },
    "retail-customer": "2494363",
    "retailer-order-reference": "23459156743",
    "creation-date": "${NOW}"
  },
  "gaming-product-orders": {
    "http://www.operator.com/gaming-products/foo": {
    	"bets": [
      	{
          "cats": [4, 7, 9, 21, 45],
          "dogs": [0, 1]
        }
      ],
      "participation-pools": {
        "first": "${IN_TWO_DAYS}",
        "draw-count": 2
      }
   },
   "http://www.operator.com/gaming-products/bar": {
     "bets": [
       {
         "drinks": [7, 9, 21, 88]
       }
     ],
     "participation-pools": {
       "cycles": ["AM"],
       "first-draw": "${IN_THREE_DAYS}",
       "draw-count": 4
     }
   }
  }
}
EOF
)
