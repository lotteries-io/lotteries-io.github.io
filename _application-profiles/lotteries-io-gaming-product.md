---
layout: page
title: Lotteries.io Gaming Product
---

## Information about Gaming Products

The gaming product has its own home page, again a HAL-JSON document which gives information about:

* optionally, a link to the [Reference Gaming Product](../link-relationships/reference-gaming-product)
* a link to the [Current Winning Scheme](../link-relationships/current-winning-scheme)
* a link to the current [Participation Pool Specification Scheme](../link-relationships/participation-pool-specification-scheme)
* a link to the [Current Betting Scheme](../link-relationships/current-betting-scheme)
* a link to the [Next Participation Pool](../link-relationships/next-participation-pool) to close (i.e. referencing the upcoming draw).
* a link to the [Previous Participation Pool](../link-relationships/previous-participation-pool) to close (i.e. referencing the last draw)
* the [Canonical Name](../properties/canonical-name) of the [Gaming Product](../concepts/gaming-product)
* a link to navigate all [Participation Pools](../link-relationships/participation-pools)

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
      "lo:reference-gaming-product":{
         "href":"http://www.operator2.com/gaming-products/foo"
      },
      "lo:current-winning-scheme":{
         "href":"http:/www.operator.com/gaming-products/product1/winning-scheme1"
      },
      "lo:participation-pool-specification-scheme":{
         "href":"http://www.operator.com/gaming-products/product1/participation-pool-specification-scheme1"
      },
      "lo:current-betting-scheme":{
         "href":"http://www.operator.com/gaming-products/product1/betting-scheme1"
      },
      "lo:next-participation-pool":{
         "href":"http://www.operator.com/gaming-products/product1/participation-pools/123"
      },
      "lo:previous-participation-pool":{
         "href":"http://www.operator.com/gaming-products/product1/participation-pools/122"
      },
      "lo:participation-pools":{
         "href":"http://www.operator.com/gaming-products/product1/participation-pools{?fromDate,toDate}",
         "templated":true
      },
      "self":{
         "href":"http://www.operator.com/gaming-products/product1"
      }
   },
   "canonical-name":"Product One"
}
{% endhighlight %}

## Enumerating and Navigating Participation Pools

A resource listing participation pools is essentially an enhanced series of links sorted chronological by the `draw-time` of the reference `draw`, pools with earlier reference draws coming before later ones. Standard `next` and `prev` link relationships are used to navigate paged resources.

The links are enhanced with additional properties:
* [pool-status](../properties/pool-status)
* [pool-statistics](../properties/pool-statistics). Optional. Only displayed if client is entitled to view this dat.ag

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
