---
layout: page
title: Order Search
---

# Order Search

Links to a resource that searches for [Orders](../concepts/order) according to the submitted URL parameters. The following variables are defined for use in a URI Template:

* `retailer/href` - the URI identifying the [Retailer](../concepts/retailer) that submitted the order. Note that normally a retailer may only view its own orders. Expect a `403 Forbidden` if a retailer client attempts to attempt resources that belong to another.
* `retail-customer/id` - the string identifying the [Retail Customer](../concepts/retail-customer) on whose behalf the order was submitted. Note that a retailer client may only search for orders that were submitted on behalf of customers of that retailer. Otherwise, expect a `403 Forbidden`.
* `retailer-order-reference/id` - the string identifying the order at the retailer. Normally this should result in precisely one link, or none. Again, a retailer client may only search for orders that it submitted itself.
* `fromDate` - defines the earliest creation date (at the operator) to be returned, ISO formattted
* `toDate` - deifnes the latest creation date (at the operator) to be returend, ISO formatted
* `processing-state` - constraints the [Processing State](../properties/processing-state) of the orders returned to be equal to the value supplied.
