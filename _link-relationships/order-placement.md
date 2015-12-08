---
layout: page
title: Order Placement
---
# Order Placement Link Relationship

Defines a link to a resource where a document describing an [Order](../concepts/order) that is compatible with the operator's application [Gaming Product](../concepts/gaming-product) profiles can be POSTed.

The expectation is that - subject to authorisation, etc - the document will be accepted for [Order Processing](../concepts/order-processing), creating a new resource. The response code will correspondingly be 201 and the location of the new resource will be in the `Location` header.


