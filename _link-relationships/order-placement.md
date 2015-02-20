---
layout: page
title: Order Placement Link Relationship
---
# Order Placement Link Relationship
Defines a link to a resource where a document describing an [order](../concepts/order) that is compatible with the operator's application [gaming product](../concepts/gaming-product) profiles can be POSTed.

The expectation is that - subject to authorisation, etc - the document will be accepted for [order processing](../concepts/order-processing), creating a new resource. The response code will correspondingly be 201 and the location of the new resource will be in the `Location` header.


