---
layout: page
title: Nominal Price
---

# Nominal Price

A map of price elements.

The keys are (normally) URIs describing [Gaming Products](../concepts/gaming-product), but may also include various non-gaming related fees that are to be described in an operator application profile.

The values are normal monetary units and hence an object consisting at least of:

* `currency`, the three letter ISO 4217 currency code
* `amount`, the amount in major currency units, a period, and the amount in minor currency units.

For example:

{% highlight json %}
{
  "nominal-price": {
    "http://www.operator.com/gaming-products/product1": {
      "currency": "USD",
      "amount": "12.50"
    }
  }
}

{% endhighlight %}
