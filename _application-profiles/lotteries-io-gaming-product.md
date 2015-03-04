---
layout: page
title: Lotteries.io Gaming Product
---

# Lotteries.io Gaming Product

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
