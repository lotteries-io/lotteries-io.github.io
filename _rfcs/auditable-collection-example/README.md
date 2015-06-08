# README

This directory contains a walk-through of the construction and validation of an
auditable collection of orders and order processing result documents and their
associated signatures and timestamp.

We start with two orders from a fictional retailer (http://www.retailer.com) at
a fictional operator (http://www.operator.com) for some equally fictional gaming
products (http://www.operator.com/gaming-products/foo and
http://www.operator.com/gaming-products/bar).

These are represented by the files `order1.json` and `order2.json`.

## Preconditions

The examples here run using `openssl` and `bash` and have been tested on Fedora 22 Linux.

## Getting Started

Note that the set up and generation scripts below are destructive and lead to the deletion of existing directories and their contents before keys and certificates are created.

### Certificate Authority

First, we need a certificate authority, so we'll set up a trivial one in the local directory `ca`, one that doesn't even protect its private key.

Run:

```
./setup-ca.sh
```

This generates keys, a self-signed certificate and the most basic file structure needed by openssl.

### Keys and Certificates for Retailer and Operator

We now set up the private/public key pairs for our two organisations, *retailer*
and *operator*. We generate certificate signing requests for both and sign these using the CA we just up.

Run:

```
./generateKeysAndCerts.sh
```

The requisite artefacts are set up in the directories `retailer` and `operator`.

First, lets compute the sha256 hash of each using openssl and adjust the output
to be URL safe - in other words recode '+' to '-' and '/' to '_' as in
"modified bas64 for URL" (see http://en.wikipedia.org/wiki/Base64)

openssl dgst -sha256 -binary order1.json | base64 > example1.json.sha256
openssl dgst -sha256 -binary order2.json | base64 > example2.json.sha256
