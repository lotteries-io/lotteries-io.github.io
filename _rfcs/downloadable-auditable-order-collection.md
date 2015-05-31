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

* retailers. For each retailer identifiable by a URI in the order document, a non-empty set of certificates whose validity spans should cover the time span represented by the earliest and latest [creation time](../properties/creation-time) properties in the order document.
* the operator. A non-empty set of certificates covering the time span represented by the earliest and latest [creation time](../properties/creation-time) properties in the terminal order processing state documents.
* the timestamping authorities being used. As for retailer and operator certificates, a non-empty set of certificates should be supplied for each timestamping authority used that cover the time span represented by the earliest and latest timestamps.

Additionally, where necessary we will also need the root Certificate Authority certificates to establish the trust chain to these certificates where those CAs are not otherwise implicitly trusted.

### Data Integrity and Trust Checking

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
