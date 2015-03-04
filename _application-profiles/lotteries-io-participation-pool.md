---
layout: page
title: Lotteries.io Participation Pool
---

# Lotteries.io Participation Pool


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
