---
layout: page
title: Lotteries.io Web Application Profile
---

# lotteries.io Web Application Profile

This page defines the generic Application Profile for lottery applications. It is an application profile in the sense of RFC 6906 [The 'profile' Link Relation Type'](https://www.ietf.org/rfc/rfc6906.txt). It adds additional semantics to [HAL-JSON](http://stateless.co/hal_specification.html).

It is intended to be *extended* by operators to add their own particular semantics and requirements.

# Placing an Order

The first use case is for a [Retailer](../concepts/retailer) to place an [Order](../concepts/order) with an [Operator](../concepts/operator) on behalf of a [Retail Customer](../concepts/retail-customer).

[Orders](../concepts/order) may be placed at a resource discovered by navigating the [order-placement](../link-relationships/order-placement) link from the starting resource.

The [Gaming Products](../concepts/gaming-product) on offer are discovered by following [available-gaming-product](../link-relationships/available-gaming-product) links. These resources also contain descriptions of the currently valid [Betting Scheme](../concepts/betting-scheme) and [Participation Pool Specification Scheme](../concepts/participation-pool-specification-scheme) for the product.

## The Order Document

The [Order](../concepts/order) is formulated in a JSON document that is an object with at least two fields:
* [metadata](../properties/metadata)
* [gaming-product-orders](../properties/gaming-product-order)

### Metadata Block

The metadata block contains information about the origin of the order. The following definition maybe extended or overwritten by operator application profiles.

Informed by the Semantic Web, and Linked Data, the majority of metadata can be given in the form of links, and so we use the HAL-JSON conventions. The following links are expected:
* [retailer](../link-relationships/retailer), the URI that is agreed to represent the retailer. Normally allocated by the operator.
* [retail-customer](../link-relationships/retail-customer), the URI that represents the [Retail Customer](../concepts/retail-customer).
* [retailer-reference](../link-relationships/retailer-order-reference), the URI that represents the [Order](../concepts/order) at the retailer. Used for correlation purposes.

If no resolvable HTTP(s) URLs are available, then URNs should be used, the custom naming scheme to be agreed between the parties.

Additional, provide:
* [creation-timestamp](../properties/creation-date), the date and time when the order document was created at the retailer. This may be used to interpret the retailer's intentions with regard to the [Participation Pools](../concepts/participation-pool) the [Participation Pool Specification](../concepts/participation-pool-specification) in the [Gaming Product Orders](../concepts/gaming-product-order) defined below.

For example:
```JSON
{
    "metadata":{
		"_links": {
			"curies": [{
				"name": "lo",
				"href": "http://www.lotteries.io/link-relationships/{rel}",
				"templated": true
			}],
			"lo:retailer": {
				"href": "http://www.operator.com/entities/retailer"
			},
			"lo:retail-customer":{
				"href":"http://www.retailer.com/customers/47890"
			},
			"lo:retailer-order-reference": {
				"href": "http://www.retailer.com/orders/1234"
			}
			
		},
        "creation-timestamp": "2015-02-18T04:57:56Z"
    }
}
```

### Gaming Product Order Block

The gaming product orders block contains [Gaming Product Order](../concepts/gaming-product-order) keyed on the URIs that identify a [Gaming Product](../concepts/gaming-product) at the operator. These URIs must exist and the products must be available.

#### Gaming Product Order
A gaming product order specifies unambiguously which [Bets](../concepts/bet) are to be placed in which [Participation Pools](../concepts/participation-pool) for that [Gaming Product](../concepts/gaming-product).

It thus has two properties:
* [bets](../properties/bets), a list of [Bet Specifications](../concepts/bet-specification) that produce bets in that are valid according to the [Betting Schemes](../concept/betting-scheme) of all the [Participation Pools](../concepts/participation-pool) specified.
* [participation-pools](../properties/participation-pools), a [Participation Pool Specification](../concepts/participation-pool-specification) that can be evaluated to a set of [Participation Pools].

For example:
```JSON
{
   "gaming-products-orders":{
		"curies": [{
				"name": "op",
				"href": "http://www.operator.com/gaming-products/{rel}",
				"templated": true
			}],
        "op:example": {
            "bets":[
                {
                    "foo":[1, 2, 3, 4, 5],
                    "bar": [1, 8]
                },
                {
                    "foo": [2, 4, 6, 29, 32],
                    "bar": [4, 5]
                }
            ],
            "participation-pools":{
                "next": 8
            }
        }
    }
}
``` 

### Signing the Order HTTP Request
The order HTTP request is to be digitally signed by the retailer using the scheme described in the draft IETF Standard [Signing HTTP Messages](https://tools.ietf.org/html/draft-cavage-http-signatures-03).

