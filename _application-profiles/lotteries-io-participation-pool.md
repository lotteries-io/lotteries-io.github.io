---
layout: page
title: Lotteries.io Participation Pool
---

# Lotteries.io Participation Pool


## Information about Participation Pools

A resource describing a [Participation Pool](../concepts/participation-pool) supplies at least the following information:

* link to a resource describing the [Gaming Product](../link-relationships/gaming-product).
* link to a resource describing the reference [Draw](../link-relationships/draw)
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
     "lo:draw": {
       "href": "http://www.operator.com/draws/45678"
      },
      "lo:gaming-product-draw-view": {
	"href": "http://www.operator.com/gaming-products/product1/draw-view/45678"
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

## Gaming Product Draw Views

The [Gaming Product Draw View](../concepts/gaming-product-draw-view) gives additional information about how a [Gaming Product](../concepts/gaming-product) views a draw - or rather, how it is organised around draws. For instance, a classic lottery product may define Jackpots or collect information about total stakes, winnings distributions after a draw, etc.

Only very high-level guidelines can be created at this level. The document should include, at least::

* a link to the product whose view on the draw is being described [gaming-product](../link-relationships/gaming-product)
* a link to the draw being referenced [draw](../link-relationships/draw)

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
     "lo:draw": {
       "href": "http://www.operator.com/draws/45678"
      }
   }
}
{% endhighlight %}

Further details are to be specified, where appropriate, in the definitions of [Gaming Products](../concepts/gaming-product) at the [Operator](../concepts/operator).

## Enumerating and Navigating Participation Pools

A resource listing participation pools is essentially an enhanced series of links sorted chronological by the `draw-time` of the reference `draw`, pools with earlier reference draws coming before later ones. Standard `next` and `prev` link relationships are used to navigate paged resources.

The links are enhanced with additional properties: 

* [pool-status](../properties/pool-status)
* [pool-statistics](../properties/pool-statistics). Optional. Only displayed if client is entitled to view this data.

An example listing might look like:

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
      "lo:participation-pool":[
         {
            "href":"http://www.operator.com/gaming-products/product1/participation-pools/122",
            "pool-status": "open",
            "pool-statistics": {
              "orders": 5000,
              "bet-specifications": 15500,
              "bets": 21345
            }
         },
         {
            "href":"http://www.operator.com/gaming-products/product1/participation-pools/121",
            "pool-status": "closed",
            "pool-statistics": {
              "orders": 34664,
              "bet-specifications": 55500,
              "bets":84231
            }
         }
      ],
      "next":{
         "href":"http://www.operator.com/gaming-products/product1/participation-pools?page=3"
      },
      "prev":{
         "href":"http://www.operator.com/gaming-products/product1/participation-pools?page=1"
      },
      "lo:gaming-product":{
         "href":"http://www.operator.com/gaming-products/product1"
      },
      "self":{
         "href":"http://www.operator.com/gaming-products/product1/participation-pools?page=2"
      }
   }
}

{% endhighlight %}
