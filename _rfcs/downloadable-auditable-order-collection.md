# Downloadable Auditable Lottery Order Collections

## Introduction

With very large prizes typically available, the lottery business is characterised by the need for the operator business to be transparent and auditable. This auditability must be available both on and off the running operator transaction systems. And it must be possible to audit the [Orders](../concepts/order) and [Order Processing State Documents](../concepts/order-processing-state) using independently developed code given just various PKI certificates as input. 

In order to achieve this goal a well-known format is required that provides a collection of orders and their processing results along with the requisite signatures and timestamps. That collection will be of size 1 - N and be the result of some search for orders, for example as the result of:
* searching for a given order with a [Retailer Order Reference](../properties/retailer-order-reference).
* browsing for an order and downloading it
* searching for orders associated with a [Retail Customer](../properties/retail-customer).
* downloading a given [Participation Pool](../concepts/participation-pool).
* internal fraud management, auditors or regulators reviewing the entire game data for a given period

The downloadable collection needs to provide all that is necessary to allow stakeholders ascertain whether game data is correct and unchanged. The most important use case is to show that claims for big prizes may go ahead as the data concerned has demonstrably not been subject to manipulation or fraud.

We anticipate that an auditor would want the following questions answered:

* is the [Order](../concepts/order) data actually what the [Retailer](../concepts/retailer) originally placed? A positive answer shows that no changes have been made to the order either on its way to the operator or within the operator environment, and that order really was from that retailer and was not faked. A positive answer assumes that the key management for the retailer is adequate.
* was exactly this order data accepted by the operator? A positive answer reinforces the assertion that no further changes took place, that the operator has taken on responsibility for the bets expressed by exactly that order data and no other.
* did the acceptance really come from the operator? A positive answer shows (assuming adequate key management by the operator) that it really was the operator processes that took on responsibilty and not some rogue instance.
* when was the order accepted by the operator? A positive answer can be used to show that the order was accepted before a given [Draw](../concepts/draw) specified in a [Participation Pool Specification](../concepts/participation-pool-specification) contained in the [Gaming Product Orders](../concepts/gaming-product-order) in the order document. This, in turn, shows that [Order Processing](../concepts/order-processing) was correctly completed before the draw - and hence without any fraudulent knowledge of the draw outcome.
* are the statements about the timing trustworthy? A positive answer shows that trusted timestamping authorities with reliable clocks and processes were used to create the timing statements.

## Input Required
 
For this we will need to provide, for each order:

* the original order
* the further header data that went into the retailer signature.
* the retailer HTTP signature
* the terminal order processing state document
* the operator signature over the order processing result document
* the timestamp of the TSA over the operator signature

## Collection Archive Structure

In order to process such data, we need to be define a set of conventions for an archive file that can be made available by an operator system. This archive file with its well-known locations can then be processe d

First, it seems appropriate to use a widely available archive

Let us imagine the pool as a ZIP containing a set of directories, each directory being named after the sha-256 hash of the original order (and what we use for the identity of the order in ZOE). Within this directory we would then place the following files:
* order (the raw order data)
* order.headers (the headers that are input into the http signature routine, including a pseudo `request-target` header, necessarily including the Digest header and including the signature, each on a new line as per HTTP)
* order.result (the processing result document from the operator, which must be of status `accepted`). This includes an `order-digest` field over the `order.json`.
* order.result.signature. A properties document with three fields:
** `signature-algorithm`. The standardised (as per Lotteries.io RFC) algorithm name for the signature algorithm used
** `signature-value`. The base64 encoded operator signature, as per http://www.lotteries.io/rfcs/content-signature, over the `order.result` document
** `signature-timestamp`. The base64 encoded RFC 3161 timestamp response over the operator signature as per http://www.lotteries.io/rfcs/content-signature

There should also be a metadata file with the following fields:
* `gaming-product`: The "well-known" URL of the gaming product concerned
* `participation-pool`: the URL of the pool at the operator
* `draw-time`: The date and time of the draw in ISO 8601 format, preferably in UTC, as follows: 2015-02-23T05:12:17Z. 

## Routine
 
A full validation routine will require as input:
* a set of retailer certificates
* the operator certificate
* a set of trusted timestamping authority certificates
* the time of the draw
* a function to extract the participation pools for the gaming product concerned from the order so as to check whether the order has really specified bets for the pool being validated
 
The full validation routine's logic is then:
* create an accumulator for validation errors. This should (ideally) always be empty when the validation routine has completed.
* for every directory in the ZIP file (this can be wonderfully parallelised, yeah)
** validate that the Digest header is correct for the order.json
** validate that the order actually specifies participation in the pool being checked
** validate that the retailer signature is correct and can be checked with the appropriate retailer certificate
** if reachable, check the validity status of the retailer certificate via OCSP (this is optional, obviously)
** check that the order-digest in the order result document matches the original order
** check that the order-result states "accepted"
** check the operator signature. Does it match the order-result document? Is it correct regarding the operator certificate?
** if reachable, check the validity status of the operator certificate via OCSP (again, obviously optional)
** check that the timestamp is over the supplied operator signature
** check that the timestamp signature is supplied by one of the trusted TSAs whose certificates were supplied in the input 
** check that the time in the timestamp is before the participation pool draw time

Any errors should be collected in the accumulator.

On completion, display results in a form to be defined by the product manager.
