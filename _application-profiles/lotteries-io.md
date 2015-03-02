---
layout: page
title: Lotteries.io Web Application Profile
---

# lotteries.io Web Application Profile

This page defines the generic Application Profile for lottery applications. It is an application profile in the sense of RFC 6906 [The 'profile' Link Relation Type'](https://www.ietf.org/rfc/rfc6906.txt). It adds additional semantics to [HAL-JSON](http://stateless.co/hal_specification.html).

It is intended to be *extended* by operators to add their own particular semantics and requirements.

# Home Document

There is a `home` document available. The resource is a HAL-JSON document with various links to key resources.

# Placing an Order

The first use case is for a [Retailer](../concepts/retailer) to place an [Order](../concepts/order) with an [Operator](../concepts/operator) on behalf of a [Retail Customer](../concepts/retail-customer).

[Orders](../concepts/order) may be placed at a resource discovered by navigating the [order-placement](../link-relationships/order-placement) link from the home document.

The [Gaming Products](../concepts/gaming-product) on offer are discovered by following [available-gaming-product](../link-relationships/available-gaming-product) links. These resources also contain descriptions of the currently valid [Betting Scheme](../concepts/betting-scheme), [Winning Scheme](../concepts/winning-scheme) and [Participation Pool Specification Scheme](../concepts/participation-pool-specification-scheme) for the product.

## The Order Document

The [Order](../concepts/order) is formulated in a JSON document that is an object with at least two fields:

- [metadata](../properties/metadata)
- [gaming-product-orders](../properties/gaming-product-orders)

### Metadata Block

The metadata block contains information about the origin of the order. The following definition maybe extended or overwritten by operator application profiles.

Informed by the Semantic Web, and Linked Data, the majority of metadata can be given in the form of links.

The following properties are expected:

- [retailer](../properties/retailer). The object should include a `href` property which is the URI that is agreed to represent the retailer. May be allocated by the operator. 
- [retail-customer](../properties/retail-customer). An object that should include a `href` property with a value that is the URI that represents the [Retail Customer](../concepts/retail-customer). 
- [retailer-reference](../properties/retailer-order-reference). An object that should include a `href` property with a value that is the URI that represents the identity of the [Order](../concepts/order) at the retailer. May be used for correlation purposes. Operator application profiles may specify that more customer detail should be supplied.
- [creation-timestamp](../properties/creation-date), the date and time when the order document was created at the retailer. This may be used to interpret the retailer's intentions with regard to the [Participation Pools](../concepts/participation-pool) the [Participation Pool Specification](../concepts/participation-pool-specification) in the [Gaming Product Orders](../concepts/gaming-product-order) defined below.


If no resolvable HTTP(s) URLs are available, then URNs should be used, the custom naming scheme to be agreed between the parties.

For example:
{% highlight json %}
{
  "metadata": {
    "retailer": {
      "href": "http://www.operator.com/entities/retailer"
    },
    "retail-customer": {
      "href": "http://www.retailer.com/customers/47890"
    },
    "retailer-order": {
      "href": "http://www.retailer.com/orders/1234"
    },
    "creation-date": "2015-02-18T04:57:56Z"
  },
{% endhighlight %}

### Gaming Product Order Block

The gaming product orders block contains [Gaming Product Order](../concepts/gaming-product-order) keyed on the URIs that identify a [Gaming Product](../concepts/gaming-product) at the operator. These URIs must exist and the products must be available.

#### Gaming Product Order
A gaming product order specifies unambiguously which [Bets](../concepts/bet) are to be placed in which [Participation Pools](../concepts/participation-pool) for that [Gaming Product](../concepts/gaming-product).

It thus has two properties:

* [bets](../properties/bets), a list of [Bet Specifications](../concepts/bet-specification) that produce bets in that are valid according to the [Betting Schemes](../concepts/betting-scheme) of all the [Participation Pools](../concepts/participation-pool) specified.
* [participation-pools](../properties/participation-pools), a [Participation Pool Specification](../concepts/participation-pool-specification) that can be evaluated to a set of [Participation Pools].

For example:
{% highlight json %}
{
 "gaming-products-orders":{
    "http://www.operator.com/gaming-products/example": {
    	"bets":[
      	{
        	"foo": [1, 2, 3, 4, 5],
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
{% endhighlight %}

### Signing the Order HTTP Request
The order HTTP request is to be digitally signed by the retailer using the scheme described in the draft IETF Standard [Signing HTTP Messages](https://tools.ietf.org/html/draft-cavage-http-signatures-03). A `Digest` header for the HTTP entity as per [RFC 3230](http://tools.ietf.org/html/rfc3230) MUST be set and SHOULD be at least SHA-256. MD5 and SHA1 MAY NOT be used as they are too weak.

## Initial Operator Order Processing

On receipt of the [Order](../concepts/order) document, the [Operator](../concepts/operator) will perform some initial syntactical and semantic checks.

If these fail, then a `400 Bad Request` will be returned along with an appropriate HTTP [Problem Details](https://tools.ietf.org/html/draft-ietf-appsawg-http-problem-00) document that supplies details of the issue encountered.

If these pass, and there is not already a representation of the order present at the operator, then a `201 Created` is returned, the URL in the `Location` header being the [Order Processing State](../concepts/order-processing-state) resource.

If there is already a representation of the order at the operator, then  a `303 See Other` is returned, the URL in the `Location` header being the [Order Processing State](../concepts/order-processing-state).

## Operator Order Resource

If an [Operator](../concepts/operator) accepts the [Order](../concepts/order) for processing, the Operator undertakes to attempt to do what work is necessary to be able to accept the bets in the [Gaming Product Orders](../concepts/gaming-product-order) bindingly. Exactly what work that is is encapsulated within the operator systems.

Accepting the order for processing means that a new resource is created in the operator system. This resource is *more* than just the order document and the HTTP request signature that is received from the [Retailer](../concepts/retailer).

The order resource at the operator consists of:

* a link to a byte-precise copy of the [Original Retailer Order](../link-relationships/original-retailer-order) and headers submitted by the retailer. Add a `request-target` header that corresponds to the original POST and target URI in order to make the signature header reproducible. 
* a link to a resource describing the [Order Processing State](../link-relationships/order-processing-state) of the order.
* [metadata](../properties/metadata), as from the original order
* [gaming-product-orders](../properties/gaming-product-orders), as from the original order

### Order Processing State

The processing state is exposed as its own resource with at least the following properties:

* link back to the [Order](../link-relationships/order) resource at the operator
* link with [Retailer Order Reference](../link-relationships/retailer-order-reference)
* [processing-state](../properties/processing-state)

If the order was `accepted`, then the resource will also include:
* [timestamp](../properties/timestamp)
* [nominal-price](../properties/nominal-price)

If the order was `rejected` or `failed` then the resource will also include a description of the reasons why in the form of an embedded [HTTP Problem Document](https://tools.ietf.org/html/draft-ietf-appsawg-http-problem-00).

If the state is terminal (accepted, rejected, failed) then the HTTP Response will also be digitally signed by the [Operator](../concepts/operator).
 

# Discovering Gaming Products

A retailer must be in a position to discover which [Gaming Products](../concepts/gaming-product) are available.

Consequently, the home document provides links to [Available Gaming Groducts](../link-relationships/available-gaming-product).

{% highlight json%}

{
	"_links": {
		"http://www.lotteries.io/link-relationships/available-gaming-product": [{
				"href": "/gaming-products/product1"
			}, {
				"href": "/gaming-products/product2"
			}
		]}
}

{% endhighlight %}

Navigating these links provides more detail about the individual [Gaming Products](../concepts/gaming-product).

## Information about Gaming Products

The gaming product has its own home page, again a HAL-JSON document which gives information about:

* optionally, a link to the [Reference Gaming Product](../link-relationships/reference-gaming-product)
* a link to the [Current Winning Scheme](../link-relationships/current-winning-scheme)
* a link to the current [Participation Pool Specification Scheme](../link-relationships/participation-pool-specification-scheme)
* a link to the [Current Betting Scheme](../link-relationships/current-betting-scheme)
* a link to the [Next Participation Pool](../link-relationships/next-participation-pool) to close (i.e. referencing the upcoming draw).
* a link to the [Previous Participation Pool](../link-relationships/previous-participation-pool) to close (i.e. referencing the last draw)
* the [Canonical Name](../properties/canonical-name) of the [Gaming Product](../concepts/gaming-product)
* any other data that might be necessary

{% highlight json%}
{
	"_links": {
	  "curies": [
	    {
	      "name": "lo",
	      "href": "http://www.lotteries.io/link-relationships/{link-relationship}",
		  "templated": true
	    }
	  ],
	  "lo:reference-gaming-product": {
        "href": "http://www.operator2.com/gaming-products/foo"
	  },
      "lo:current-winning-scheme": {
		"href": "http:/www.operator.com/gaming-products/product1/winning-scheme1"
      },
      "lo:participation-pool-specification-scheme": {
        "href": "http://www.operator.com/gaming-products/product1/participation-pool-specification-scheme1"
	  },
      "lo:current-betting-scheme": {
		"href": "http://www.operator.com/gaming-products/product1/betting-scheme1"
      },
      "lo:next-participation-pool": {
		"href": "http://www.operator.com/gaming-products/product1/participation-pools/123"
      },
	  "lo:previous-participation-pool": {
		"href": "http://www.operator.com/gaming-products/product1/participation-pools/122"
      },
	  "self": {
		"href": "http://www.operator.com/gaming-products/product1"
	  }
   },
   "canonical-name": "Product One"
}

{% endhighlight %}

## Information about Participation Pools

A resource describing a [Participation Pool](../concepts/participation-pool) supplies at least the following information:

* link to a resource describing the [Gaming Product](../link-relationships/gaming-product).
* link to a resource describing the [Reference Draw](../link-relationships/reference-draw)
* optionally, a link to a resource describing the [Gaming Product Draw View](../link-relationships/gaming-product-draw-view) if this should be needed
* link to a resource describing the [Betting Scheme](../link-relationships/betting-scheme) that defines valid bets for the pool
* link to a resource describing the [Winning Scheme](../link-relationships/winning-scheme) that defines how winning classes and winnings are computed for the pool
* the [Opening Time](../properties/opening-time) of the pool in ISO 8601 format at second level precision, preferably in UTC.
* the [Closing Time](../properties/closing-time) of the pool in ISO 8601 format at second level precision, preferably in UTC.
* the [Fail-safe Time](../properties/fail-safe-time) of the pool in ISO 8601 format at second level precision, preferably in UTC.

{% highlight json%}
{
	"_links": {
	  "curies": [
	    {
	      "name": "lo",
	      "href": "http://www.lotteries.io/link-relationships/{link-relationship}",
		  "templated": true
	    }
	  ],
	  "lo:gaming-product": {
        "href": "http://www.operator.com/gaming-products/product1"
	  },
      "lo:reference-draw": {
		"href": "http://www.operator.com/draws/45678"
      },
      "lo:gaming-product-draw-view": {
		"href": "http://www.operator.com/gaming-products/product1/draw-view/45678
       },
      "lo:betting-scheme": {
         "href": "http://www.operator.com/gaming-products/product1/betting-scheme1"
	  },
      "lo:winning-scheme": {
	     "href": "http://www.operator.com/gaming-products/product1/winning-scheme1"
      },
	  "self": {
		"href": "http://www.operator.com/gaming-products/product1/participation-pools/123"
	  }
   },
   "opening-time": "2015-02-26T18:00:00Z",
   "closing-time": "2015-02-26T18:30:00Z",
   "fail-safe-time": "2015-02-26T18:40:00Z",
}

{% endhighlight %}
