---
layout: page
title: Lotteries.io Home
---

# Home Resource

There is a `home` document available. The resource is a HAL-JSON document with various links to key resources.

## Discovering where to place orders
[Orders](../concepts/order) may be placed at a resource discovered by navigating the [order-placement](../link-relationships/order-placement) link from the home document.

## Discovering Gaming Products

The [Gaming Products](../concepts/gaming-product) on offer are discovered by following [available-gaming-product](../link-relationships/available-gaming-product) links.

## Discovering Draw Information

If the service offers information about [Draw Series](../concepts/draw-series) then these can be discovered by following [available-draw-series](../link-relationships/available-draw-series) links.


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
      "lo:available-gaming-product":[
         {
            "href":"/gaming-products/product1"
         },
         {
            "href":"/gaming-products/product2"
         }
      ]
   },
   "lo:order-placement":{
      "href":"/orders"
   },
   "lo:available-draw-series":[
      {
         "href":"/draw-series/series1"
      },
      {
         "href":"/draw-series/series2"
      }
   ]
}
{% endhighlight %}

