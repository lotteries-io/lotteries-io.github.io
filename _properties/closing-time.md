---
layout: page
title: closing Time
---

# Closing Time

On a representation of a [Particpation Pool](../concepts/participation-pool), property stating the closing time for that pool, that is, the point in time from which [Gaming Product Orders](../concepts/gaming-product-order) to place [Bets](../concepts/bet) in the pool will be rejected automatically.

In other words, the [Operator](../concepts/operator) will make no attempt to process bets for the pool after this time has passed. 

[Gaming Product Orders](../concepts/gaming-product-order) which are being processed when this time is reached will continue to be worked on until the [Fail Safe Time](fail-safe-time) is reached.

The property's form should be a string formatted in ISO 8601, preferably in UTC as follows: 2015-02-23T05:12:17Z.
