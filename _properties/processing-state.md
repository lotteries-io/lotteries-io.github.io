---
layout: page
title: Processing State
---

# Processing State

Property of an [Order Processing State](../concepts/order-processing-state) that describes the formal state of order processing. Value is one of:

* `in-process`. The order has been accepted for processing and the outcome is not yet known.
* `accepted`. The order has been accepted as a whole. All [Bets](../concepts/bets) for all [Participation Pools](../concepts/participation-pool) specified in the embedded [Gaming Product Orders](../concepts/gaming-product-order) have been accepted and the [Operator](../concepts/operator) will be honoured.
* `rejected`. The order has been rejected for formal or other reasons and *no* [Bets](../concepts/bets) in any [Participation Pools](../concepts/participation-pool) specified in the embedded [Gaming Product Orders](../concepts/gaming-product-order) will be honoured by the [Operator](../concepts/operator).
* `failed`. The order could not be fulfilled for technical reasons and *no* [Bets](../concepts/bets) in any [Participation Pools](../concepts/participation-pool) specified in the embedded [Gaming Product Orders](../concepts/gaming-product-order) will be honoured by the [Operator](../concepts/operator).
