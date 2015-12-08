# README

This directory contains a walk-through of the construction and validation of an
auditable collection of orders and order processing result documents and their
associated signatures and timestamp.

We start with two orders from a fictional retailer (http://www.retailer.com) at
a fictional operator (http://www.operator.com) for some equally fictional gaming
products (http://www.operator.com/gaming-products/foo and
http://www.operator.com/gaming-products/bar).

These are generated from the shell templates in `raw-orders`.

## Preconditions

You must have installed `jq` to enable working with JSON documents on the shell.

The examples here run using `openssl` and `bash` and have been tested on Mac OS X El Capitan. On Mac OS X you will need to
ensure that you have an up to date version of `openssl` (in order to generate timestamps), for example by using:
```
brew install openssl
brew link openssl --force
```

## Getting Started

Note that the set up and generation scripts below are destructive and lead to the deletion of existing directories and their contents before keys and certificates are created.

### Certificate Authority

First, we need a certificate authority, so we'll set up a trivial one in the local directory `ca`, one that doesn't even protect its private key.

Run:

```
./setup-ca.sh
```

This generates keys, a self-signed certificate and the most basic file structure needed by openssl.

You can clear this up with the script `reset-ca.sh`.

### Keys and Certificates for Retailer and Operator and Timestamp Authority

We now set up the private/public key pairs for our two organisations, *retailer*
and *operator*. We generate certificate signing requests for both and sign these using the CA we just up.

We also create a Timestamping Authority, *tsa*.

Run:

```
./generateKeysAndCerts.sh
```

The requisite artefacts are set up in the directories `retailer`, `operator` and `tsa`.

### Generating a downloadable collection

With the above pre-conditions in place, we can now generate a downloadable, auditable collection in the correct format.

Run:
```
createCollection.sh
```

This runs through the template files in `raw-orders`, generates the final JSON documents with recent timestamps, signs them in the name of the retailer, draws up an order acceptance document, signs that and then timestamps the operator signature.

At this point, we don't supply a `metadata.json` file.

The result is a file: `downloadable-collection.zip` in the appropriate format.

### Validating a downloadable collection

TODO
