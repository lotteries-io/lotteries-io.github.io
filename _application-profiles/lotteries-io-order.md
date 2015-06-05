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

The metadata block contains information about the origin of the order. As always, the following definition may be extended or overwritten by operator application profiles.

The following properties are expected:

- [retailer](../properties/retailer). The object should include a `href` property which is the URI that is agreed to represent the retailer. May be allocated by the operator.
- [retail-customer](../properties/retail-customer). A string that identifies the [Retail Customer](../concepts/retail-customer) within the context of the [Retailer](../concepts/retailer). Operator application profiles may specify that more customer detail should be supplied in the form of an object.
- [retailer-order-reference](../properties/retailer-order-reference). A string that identifies the [Order](../concepts/order) at the [Retailer](../concepts/retailer). May be used for correlation purposes.
- [retailer-brand](../properties/retailer-brand). An *optional* object. If present, should include a `href` property with a value that is the URI that represents the identity of the retailer's brand, if orders are being sold under a variety of labels by a single retailer entity. If absent, implicitly the same as the [retailer](../properties/retailer).
- [creation-timestamp](../properties/creation-date), the date and time when the order document was created at the retailer. This may be used to interpret the retailer's intentions with regard to the [Participation Pools](../concepts/participation-pool) the [Participation Pool Specification](../concepts/participation-pool-specification) in the [Gaming Product Orders](../concepts/gaming-product-order) defined below.


If no resolvable HTTP(s) URLs are available, then URNs should be used, the custom naming scheme to be agreed between the parties.

For example:
{% highlight json %}
{
  "metadata": {
    "retailer": {
      "href": "http://www.operator.com/entities/retailer"
    },
    "retail-customer": "47890",
    "retailer-order-reference": "1234",
    "creation-date": "2015-02-18T04:57:56Z"
  },
{% endhighlight %}

### Gaming Product Order Block

The gaming product orders block contains [Gaming Product Order](../concepts/gaming-product-order) keyed on the URIs that identify a [Gaming Product](../concepts/gaming-product) at the operator. These URIs must exist and the products must be available.

#### Gaming Product Order
A gaming product order specifies unambiguously which [Bets](../concepts/bet) are to be placed in which [Participation Pools](../concepts/participation-pool) for that [Gaming Product](../concepts/gaming-product).

It thus has two properties:

* [bets](../properties/bets), a list of [Bet Specifications](../concepts/bet-specification) that produce bets in that are valid according to the [Betting Schemes](../concepts/betting-scheme) of all the [Participation Pools](../concepts/participation-pool) specified.
* [participation-pools](../properties/participation-pools), a [Participation Pool Specification](../concepts/participation-pool-specification) that can be evaluated to a set of [Participation Pools](../concepts/participation-pool).

For example:
{% highlight json %}
{
 "gaming-products-orders":{
    "http://www.operator.com/gaming-products/example": {
    	"bets": [
      	{
          "foo": [1, 2, 3, 4, 5],
          "bar": [1, 8]
        },
        {
          "foo": [2, 4, 6, 29, 32],
          "bar": [4, 5]
        }
      ],
      "participation-pools": {
        "next": 8
      }
   }
  }
}
{% endhighlight %}

## Signing the Order HTTP Request
The order HTTP request MUST be digitally signed by the retailer using the scheme described in the [Content Signature](../rfcs/content-signature) draft standard. The signature is over the document bytes POSTed to the order placement endpoint. It is used to verify the integrity of the order as well as its provenance. In other words:

* the hash in the signature must match the document
* the key used to sign the document must be known as belonging the retailer identified in the `metadata` block. The operator may make regular against OCSP or CRL services to check whether a certificate issued over the public key has been revoked or not. In the case that it has been revoked, the order should be rejected.

## Order Identity

*The identity of the order is considered to be a cryptographic hash over the entire body content (including whitespace, etc).*

That is **important**.

If the retailer resends the same logical content but formatted differently then it will have a different digest and be treated as a fresh order on the operator side.

Note that the same bet and participation pool specifications may be submitted multiple times - this is part of daily business. If a retailer sends the same [retailer-order-reference](../properties/retailer-order-reference) multiple times (either with the same logical content but formatted differently, or with different logical content), then they will have to deal with the additional order costs and the complexity of disentangling what they really meant themselves!

## Initial Operator Order Processing

On receipt of the [Order](../concepts/order) document, the [Operator](../concepts/operator) will perform some initial syntactical and semantic checks.

If these fail, then a `400 Bad Request` will be returned along with an appropriate HTTP [Problem Details](https://tools.ietf.org/html/draft-ietf-appsawg-http-problem-00) document that supplies details of the issue encountered.

If these pass, and there is not already a representation of the order present at the operator (as identified by the body digest), then a `201 Created` is returned, the URL in the `Location` header being the [Order Processing State](../concepts/order-processing-state) resource.

If there is already a representation of the order at the operator, then  a `303 See Other` is returned, the URL in the `Location` header being the [Order Processing State](../concepts/order-processing-state).

## Operator Order Resource

If an [Operator](../concepts/operator) accepts the [Order](../concepts/order) for processing, the Operator undertakes to attempt to do what work is necessary to be able to accept the bets in the [Gaming Product Orders](../concepts/gaming-product-order) bindingly. Exactly what work that is is encapsulated within the operator systems.

Accepting the order for processing means that a new resource is created in the operator system. This resource is *more* than just the order document and the HTTP request signature that is received from the [Retailer](../concepts/retailer).

The order resource at the operator consists of:

* a link to a byte-precise copy of the [Original Retailer Order](../link-relationships/original-retailer-order) and headers submitted by the retailer. Add a `request-target` header that corresponds to the original POST and target URI in order to make the signature header reproducible.
* a link to a resource describing the [Order Processing State](../link-relationships/order-processing-state) of the order.
* [metadata](../properties/metadata), as from the original order
* [gaming-product-orders](../properties/gaming-product-orders), as from the original order

### Order Processing Result

The result of processing the order is exposed as its own resource. Unlike other aspects of the API, the processing state is not a hypermedia document that may evolve with new properties and link relationships over time. Rather, the terminal processing state (beyond `in-process`) is a formal documentation of the acceptance or rejection (or the failure of either) of liability for the bets specified in the Gaming Product Orders.

This document is important and immutable. The operator must vouch for its veracity and the time at which it is constructed must also be reliably witnessed in order to provide transparency to all key stakeholders.

For example:

{% highlight json%}
{
  "order-digest": "SHA256=5d5b09f6dcb2d53a5fffc60c4ac0d55fabdf556069d6631545f42aa6e3500f2e",
  "retailer-order-reference": "1234567",
  "retailer": {
    "href": "http://www.operator.com/entities/retailer"
  },
  "order-processing-result": "in-process"
}
{% endhighlight %}

At least the following properties are provided:

* [order-digest](../properties/order-digest). This allows the correctness of the document with respect to the original order to be demonstrated.
* [retailer-order-reference](../properties/retailer-order-reference). This allows for simple correlation by the retailer.
* [retailer](../properties/retailer)
* [order-processing-result](../properties/order-processing-result). The interim or final result.

If the order was `accepted`, then the resource will also include:

* [nominal-price](../properties/nominal-price)

For example:

{% highlight json%}
{
  "order-digest": "sha256:5d5b09f6dcb2d53a5fffc60c4ac0d55fabdf556069d6631545f42aa6e3500f2e",
  "retailer-order-reference": "1234567",
  "retailer": {
    "href": "http://www.operator.com/entities/retailer"
  },
  "order-processing-result": "accepted",
  "nominal-price": {
    "http://www.operator.com/gaming-products/product1": {
      "currency": "EUR",
      "amount": "12.50"
    },
    "processing-fee": {
      "currency": "EUR",
      "amount": "1.00"
    }
  }
}
{% endhighlight %}

If the order was `rejected` or `failed` then the resource MAY also include a description of the reasons why in the form of an embedded [HTTP Problem Document](https://tools.ietf.org/html/draft-ietf-appsawg-http-problem-00) under the key `problem-details`.

For example:
{% highlight json%}
{
  "order-digest": "sha256:5d5b09f6dcb2d53a5fffc60c4ac0d55fabdf556069d6631545f42aa6e3500f2e",
  "retailer-order-reference": "1234567",
  "retailer": {
    "href": "http://www.operator.com/entities/retailer"
  },
  "order-processing-result": "rejected",
  "problem-details": {
    "type": "http://www.lotteries.io/problem-types/invalid-order",
    "title": "invalid order",
    "detail": "too many bets specified"
  }
}
{% endhighlight %}

If the state is terminal (`accepted`, `rejected`, or `failed`) then the HTTP Entity Body will also be digitally signed by the [Operator](../concepts/operator) as per [Content Signature](../rfcs/content-signature). Additionally, the timestamp obtained by the operator over its digital signature will be published as per [Content Signature Timestamp](../rfcs/content-signature-timestamp).

## Listing Order Links

Lists of order links may be returned from resources that enumerate orders or that return the results of searching for orders.

Such lists are essentially lists of links to operator order resources that are sorted by date of entry into the operator system. They may be paged, in which case the standard `next` and `previous` link relationships are used to move through the collection.

For example,

{% highlight json%}
{
   "_links":{
      "curies":[
         {
            "name":"lo",
            "href":"http://www.lotteries.io/link-relationships/{link-relationship}",
            "templated":true
         }
      ],
      "lo:order":[
         {
            "href":"/orders/123456"
         },
         {
            "href":"/orders/123455"
         }
      ]
   },
   "lo:orders":{
      "href":"/orders"
   },
   "self":{
      "href":"/orders/search?fromDate=2015-03-09Z?page=2"
   },
   "next":{
      "href":"/orders/search?fromDate=2015-03-09Z?page=3"
   },
   "prev":{
      "href":"/orders/search?fromDate=2015-03-09Z?page=1"
   }
}
{% endhighlight %}
