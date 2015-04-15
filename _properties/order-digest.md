---
layout: page
title: Order Digest
---

# Order Digest

The Order Digest is the cryptographic hash over an [order](../concepts/order) that has been provided as a `Digest` header by the retailer upon posting the order.

As the digest has been checked by the operator upon accepting an order it can now be used to prove to the retailer that a signed document that contains this property is in reference to the original retailer order.

The value is a string that has the same format as the `Digest` header value according to [RFC 3230](http://tools.ietf.org/html/rfc3230). The canonical algorithm names are defined as in [Content-Signature](http://www.lotteries.io/rfcs/content-signature#algorithms).

## Example Object with an Order Digest

{% highlight json%}
{
	"order-digest": "sha256=yAqXBB8VuhZrmj6PwrCXJtd4vDvZM41L7+NLRnB+vuw="
}
{% endhighlight %}
