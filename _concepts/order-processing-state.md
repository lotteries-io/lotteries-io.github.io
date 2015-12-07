---
layout: page
title: Order Processing State
---

# Order Processing State
The [Operator](operator) publishes the state of [Order Processing](order-processing) to the [Retailer](retailer) that placed the original [Order](order) on behalf of a [Retail Customer](retail-customer).

Typically, the state exposed is one of:

* `in-process`<a id="in-process"/>. The order is being worked on.
* `accepted` <a id="accepted"/>. The order has been accepted and a contract has been closed.
* `rejected` <a id="rejected"/>. The order was rejected for business reasons, no contract has been closed.
* `failed` <a id="failed"/>. The order could not be processed for technical reasons and no contract has been closed.
