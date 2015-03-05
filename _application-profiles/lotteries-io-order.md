---
layout: page
title: Lotteries.io Order
---

# Order

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
- [retailer-order-reference](../properties/retailer-order-reference). An object that should include a `href` property with a value that is the URI that represents the identity of the [Order](../concepts/order) at the retailer. May be used for correlation purposes. Operator application profiles may specify that more customer detail should be supplied.
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
    "retailer-order-reference": {
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
