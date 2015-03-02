---
layout: page
title: Original Order
---

# Original Order
A link to a resource containing the exact bytes of the original [Order](../concepts/order) document submitted by the [Retailer](../concepts/retailer).

The HTTP headers that were signed in the original request are also returned with the result. The `request-target` pseudo-header that is also signed is made into an explicit header in the returned resource.
