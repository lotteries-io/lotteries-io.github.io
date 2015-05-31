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
 
In order to be able to answer these questions reliably we need, for each order:

* the original order document, a byte-precise copy of what was submitted by the retailer
* the further header data that went into the retailer HTTP signature.
* the retailer HTTP signature
* the terminal order processing state document from the operator
* the operator signature over the order processing result document
* the timestamp of the TSA over the operator signature

## Collection Archive Structure

In order to process such data, we need to be define a set of conventions for an archive file that can be made available by an operator system. Implementations of scripts or programs to answer the above questions can then be assembled around readily available libraries.

We define the archive format to use as a **zip** file.

### Orders as Directories

The data for each order is placed in a directory named according to the URL-safe base64 encoded sha-256 hash of the original order data.

Within this directory the files with the following names and semantics are expected to be present:

* `order` (the raw order data as submitted by the [Retailer](../concepts/retailer)).
* `order.headers` (the raw HTTP headers that are input into the http signature routine, including a pseudo `request-target` header, necessarily including the `Digest` header and including the signature, each on a new line as per HTTP).
* `order.result` (the terminal [order processing state](../concepts/order-processing-state) document from the operator in JSON format. This includes an `order-digest` field over the `order.json` which allows the processing result to be correlated with the input `order`).
* `order.result.signature`. A JSON document describing an object with three string properties:
** `signature-algorithm`. The standardised (as per [Content-Signature](content-signature)) algorithm name for the signature algorithm used
** `signature-value`. The base64 encoded operator signature (as per [Content-Signature](content-signature)) over the `order.result` document
** `signature-timestamp`. The base64 encoded RFC 3161 timestamp response over the operator signature as per [Content-Signature-Timestamp](content-signature-timestamp).

### Collection Metadata
Additionally, a file `metadata.json` at the top-level of the archive *may* be supplied giving information about the query executed to compile the order collection.

For the present, we define string properties to be supplied for a collection that represents a [Participation Pool](../concepts/participation-pool).

* `gaming-product`: The "well-known" URL of the gaming product concerned
* `participation-pool`: the URL of the pool at the operator
* `draw-time`: The date and time of the draw in ISO 8601 format, preferably in UTC, for example, as follows: 2015-02-23T05:12:17Z. 

## Auditing Routines
 
One of the strengths of using open and standardised archive structures, as defined above, along with public key cryptography, is that validation and processing routines can be implemented independently of each other using programming languages and libraries of choice. This approach allows for robust validation without forcing stakeholders to use routines supplied by the operator where they may, for whatever reason, have grounds for wanting to apply their own checks to achieve fully independent auditability.
 
### Further Input 

Given the questions we postulate will be asked of the data concerning the integrity, provenance and timing of the two key documents, the order and its terminal processing state, issued by the retailer and the operator respectively we need further input - the PKI certificates associated with:

* **retailers**. For each retailer identifiable by a URI in the order document, a non-empty set of certificates whose validity spans should cover the time span represented by the earliest and latest [creation time](../properties/creation-time) properties in the order document.
* the **operator**. A non-empty set of certificates covering the time span represented by the earliest and latest [creation time](../properties/creation-time) properties in the terminal order processing state documents.
* the RFC 3161 **timestamping authorities** being used. As for retailer and operator certificates, a non-empty set of certificates should be supplied for each timestamping authority used that cover the time span represented by the earliest and latest timestamps.

Additionally, where necessary we will also need the root Certificate Authority certificates to establish the trust chain to these certificates where those CAs are not otherwise implicitly trusted.

### Data Integrity and Trust Checking

In order to validate the integrity and provenance of an individual order in the collection, the following checks should be undertaken:

1. validate the integrity and provenance of the `order` document by analysing the `order.headers` document:
  1. check the value of the `Digest` header matches the `order`
  2. check that the HTTP Signature is valid given the headers in the signature (which **must** include `Digest`) and the certificate for the retailer identified in the order's `metadata` block that was valid at the point in time identified by the `creation-time` property. If there is no such certificate, then the check fails
  3. check that the retailer certificate was issued by a trusted CA (directly or indirectly via an intermediate CA)
  4. if possible, check the retailer certificate against the issuing CA's OCSP or CRL services to ascertain if the certificate had not been revoked at the time point identified by the `creation-time` property on the order
2. validate that the `order.result` document actually refers to the `order` by comparing the `order-digest` property to the available `order` document
3. validate that integrity and provenance of the `order.result` document by analysing the `order.result.signature` document:
  1. check that the `signature-value` matches the `order-result` document given the operator certificate that was/is valid for the time in the `creation-time` property of the `order-result` document. If there is no such certificate, then the check fails
  2. if possible, check the operator certificate against the issuing CA's OCSP or CRL services to ascertain if the certificate had not been revoked at the time point identified by the `creation-time` property on the `order.result` document
  3. check that the `signature-timestamp` value refers to a hash over the `signature-value` as described in [Content Signature Timestamp](content-signature-timestamp).
  4. check that the timestamp was issued by one of the trusted timestamping authorities.

Any failure should be collected and flagged for further investigation.

### Further Checks and Processing

Given a collection of order documents and associated terminal processing state and signatures that have passed normal integrity and provenance checks, a variety of further checks and processing can be performed as required. 

For example, since the `order.result.signature` includes a trusted timestamp, we can check easily that an order document was witnessed to have been accepted before a given point in time, most likely before a [Draw](../concepts/draw). A processing routine may draw on information from the `metadata.json` file to assist or may seek user input.

Given knowledge about [Gaming Products](../concepts/gaming-product) checking and processing routines can perform more sophisticated checks at the cost of additional complexity. For example, with the appropriate [Participation Pool Specification Scheme](../concepts/participation-pool-specification-scheme) it is possible to determine whether a given [Order](../concepts/order) contained a [Gaming Product Order](../concepts/gaming-product-order) that specified a given [Participation Pool](../concepts/participation-pool). Combined with a check as to whether the [order-processing-result](../properties/order-processing-result) property on the `order.result` document is `accepted`, this logic can be used to validate that an auditable collection of orders plausibly represents a participation pool, or at least a subset thereof.

Given a [Betting Scheme](../concepts/betting-scheme), a [Draw Result](../concepts/draw-result) and a [Winning Scheme](../concepts/winning-scheme) for a given [Gaming Product](../concepts/gaming-product), offline computation of [Winning Classes](../concepts/winning-class) and [Winnings](../concepts/winning) can take place as required.
