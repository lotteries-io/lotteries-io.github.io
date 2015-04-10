---
layout: page
title: Content Signature Timestamp
---

# Content Signature Timestamp

## Introduction

The [Content Signature](content-signature) 'RFC' defines a method for providing a signature over the bytes in an HTTP Entity Body. However, it does not allow a client to ascertain *when* exactly that signature was provided. In some cases, as in that of lotteries with time-critical data this further information can be critically important in deciding whether an [Order](../concepts/order) was accepted on time or not and [Bets](../concepts/bet) in its constituent [Gaming Product Orders](../concepts/gaming-product-order) could thus be considered as legitimately being in a [Participation Pool](../concepts/participation-pool).

We therefore introduce a new custom HTTP Header: `Content-Signature-Timestamp`.

## Definition

[RFC 3161](https://www.ietf.org/rfc/rfc3161.txt) (Timestamp Protocol) defines artefacts and procedures for creating cryptographic timestamps. 

Given the *raw bytes* (**NOT** the base64 encoded variant) of a digital signature, such as embedded in the `Content-Signature` header, a `Timestamp Query` is formed using an acceptable cryptographic digest algorithm and submitted to a Timestamp Authority. The resulting validated binary, ASN.1 encoded, `Timestamp Response` provides evidence that the signature was in existence at the point in time documented in the `Timestamp Response`.

The content of the header is the base64 encoded `Timestamp Response` object obtained from the Timestamp Authority ob the basis of a query formed from the signature raw bytes.

## Example



