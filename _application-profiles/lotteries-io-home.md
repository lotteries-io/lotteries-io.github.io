---
layout: page
title: Lotteries.io Home
---

# Home Resource

There is a `home` document available. The resource is a HAL-JSON document with various links to key resources.

## Orders

### Order Placement
[Orders](../concepts/order) may be placed at a resource discovered by navigating the [order-placement](../link-relationships/order-placement) link from the home document.

### Order Enumeration and Search
[Orders](../concepts/order) may be enumerated at a resource discovered by navigating the [orders](../link-relationships/orders) link from the home document.

Note that the selection of orders that are available to navigate will depend on the authentication information of the client. In particular, the [Operator](../concepts/operator) will be able to see all orders whereas an individual [Retailer](../concepts/retailer) will only be able to see those orders submitted and 'owned' by that organisation and no others.

An [order-search](../link-relationships/order-search) link should also be provided. Again, the results will be constrained by authentication information of the client.

Both enumeration and search return a list of links to orders, as described in the [lotteries-io-order](lotteries-io-order) application profile.

## Available Gaming Products

The [Gaming Products](../concepts/gaming-product) on offer are discovered by following [available-gaming-product](../link-relationships/available-gaming-product) links.

## Draw Information

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
      "href":"/orders/placement"
   },
   "lo:orders": {
      "href":"/orders"
   },
   "lo:order-search": {
      "href":"/orders/search{?retailer/href,retail-customer/href,retailer-order-reference/href,fromDate,toDate,processing-state},
      "templated":true
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

