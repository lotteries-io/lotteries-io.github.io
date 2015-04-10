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

Digest algorithms with known weaknesses such as MD5 or SHA1 is should NOT be used.

The content of the header is the base64 encoded `Timestamp Response` object obtained from the Timestamp Authority ob the basis of a query formed from the signature raw bytes.

This header MUST NOT be used in the absence of a `Content-Signature` header as it has no referent in this case.

## Example

### Generating the Timestamp Query

Given the examples from [Content Signature](content-signature), we can start to build up sample content for this header step by step. We have a file [example.txt](example.txt) and have already computed a [raw signature](signature.raw) over it. The base64 for the signature is:

```
UNtlSkR94FjgGstW238OcfxGSvEAtCJ8wikagpPdympgO7kjiM8PFpQ06vfKOtM3hGqMhGkrEI85
pErk94ou6E/pY8N7XGYgWdrvc3I1j0yaWAfUn3yCezl7slXfIs+Ph2zP+0LGgX3bVJrhYat+65bH
LC2Fr5q2aEBWCdSfe2U80NhzFk7zCZKFcMi2xftz+m/qcJ4uEq1knABo6JMAGukgwcrgiRmu+sBD
6OEZFm8pM5eoA/akzB+j5IkgkTK1bXryJb60DOKYiB01hvKdfkxMk+X335+/n5nAuhQr990dg3mw
zFaC/g19zjVkwQ87kKZn/yA2wEI5Ni6xFHpXCg==
```

We also have some PEM files that describe certificates and keys for our Timestamping Authority including the fictional Root Certificate Authority.

We start by computing a RFC 3161 `Timestamp Query` over the raw signature.

```
openssl ts -query -data signature.raw -sha256 -no_nonce -out signature.raw.tsq
```

The query is now in the file `[signature.raw.tsq](signature.raw.tsq)`. In this case we have foregone the option to generate a random nonce and to request the full certificate from the Timestamping Authority.

To view request in human readable form, most people not being able to parse ASN.1, we can call:

```
openssl ts -query -in signature.raw.tsq -text
```

To view:
```
Version: 1
Hash Algorithm: sha256
Message data:
    0000 - 15 36 83 4e 58 f4 6d 87-f3 14 1c a5 f0 4d 45 8e   .6.NX.m......ME.
    0010 - 0b 5f 17 32 51 ca 8b 40-95 50 b9 ce cd 61 20 7e   ._.2Q..@.P...a ~
Policy OID: unspecified
Nonce: unspecified
Certificate required: no
Extensions:
```

### Generating Timestamp Response

As said Timestamping Authority is completely under our control, we can proceed to generate a `Timestamp Response` given our absolutely minimal [Openssl Config File](openssl.cnf).

```
openssl ts -config openssl.cnf -reply -queryfile signature.raw.tsq -signer timestamper-cert.pem -inkey timestamper-private-key.pem -chain root-ca-cert.pem -out signature.raw.tsr
```

We thus have a response in `signature.raw.tsr`(signature.raw.tsr). A version is checked in, generated at around lunchtime on the 10th April 2015. We can view this file in human readable form thus:

```
openssl ts -in signature.raw.tsr -text
```

which in this case returns:

```
Status info:
Status: Granted.
Status description: unspecified
Failure info: unspecified

TST info:
Version: 1
Policy OID: 1.2.3.4.1
Hash Algorithm: sha256
Message data:
    0000 - 15 36 83 4e 58 f4 6d 87-f3 14 1c a5 f0 4d 45 8e   .6.NX.m......ME.
    0010 - 0b 5f 17 32 51 ca 8b 40-95 50 b9 ce cd 61 20 7e   ._.2Q..@.P...a ~
Serial number: 0x0B
Time stamp: Apr 10 10:23:56 2015 GMT
Accuracy: unspecified
Ordering: no
Nonce: unspecified
TSA: unspecified
Extensions:
```

We now need to base64 encode the response for transport in HTTP headers.

```
base64 -w 0 signature.raw.tsr > signature.raw.tsr.base64
```

The base64 is available as [signature.raw.tsr.base64](signature.raw.tsr.base64).

The final result is thus:

```
Content-Signature-Timestamp: MIICsjADAgEAMIICqQYJKoZIhvcNAQcCoIICmjCCApYCAQMxCzAJBgUrDgMCGgUAMGMGCyqGSIb3DQEJEAEEoFQEUjBQAgEBBgQqAwQBMDEwDQYJYIZIAWUDBAIBBQAEIBU2g05Y9G2H8xQcpfBNRY4LXxcyUcqLQJVQuc7NYSB+AgELGA8yMDE1MDQxMDEwMjM1NloxggIdMIICGQIBATBnMGIxHTAbBgNVBAMMFExvdHRlcmllcy5pbyBSb290IENBMREwDwYDVQQLDAhTZWN1cml0eTEQMA4GA1UECgwHUm9vdCBDQTEPMA0GA1UEBwwGTG9uZG9uMQswCQYDVQQGEwJHQgIBATAJBgUrDgMCGgUAoIGMMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAcBgkqhkiG9w0BCQUxDxcNMTUwNDEwMTAyMzU2WjAjBgkqhkiG9w0BCQQxFgQUE9R5ho2zXSbv687+hk5uym/3+tMwKwYLKoZIhvcNAQkQAgwxHDAaMBgwFgQUT2wHiU/grLhG6k96MUhxGre9Fg8wDQYJKoZIhvcNAQEBBQAEggEAqWXjh+xDMzgdAZG3Sa788CzzOjtk0XKfxu93MeMrA9rsJaRTM2euhaWWQwti6eLd24LKg52uDHJTap8Enzl9KsWRkXSC8VMUapkFSNjb1g+49VcvtEzpTkuiwSHgU6ia2pIo2k7jTtD4hYvYLRHKiesQ78+aHQfSEve9LfSjy4YieJqfYbd0mvaVxCSz1uOgYBv5x5RQjEGkWtSqNJ939jptJFOjZVS2Kw+6cgdnZaa9aW+HmpEsxeD6fLARQvfsHBdF/hYvgklBVZjz69RsRH/e6IzJlNqe+thSJUaf6fZB3icZyXrQLznTwh8CxZhXdnhz0CP9GE430JU5leqtKw==
Content-Signature: keyId="lotteries-io",algorithm="rsa-sha256",signature="UNtlSkR94FjgGstW238OcfxGSvEAtCJ8wikagpPdympgO7kjiM8PFpQ06vfKOtM3hGqMhGkrEI85pErk94ou6E/pY8N7XGYgWdrvc3I1j0yaWAfUn3yCezl7slXfIs+Ph2zP+0LGgX3bVJrhYat+65bHLC2Fr5q2aEBWCdSfe2U80NhzFk7zCZKFcMi2xftz+m/qcJ4uEq1knABo6JMAGukgwcrgiRmu+sBD6OEZFm8pM5eoA/akzB+j5IkgkTK1bXryJb60DOKYiB01hvKdfkxMk+X335+/n5nAuhQr990dg3mwzFaC/g19zjVkwQ87kKZn/yA2wEI5Ni6xFHpXCg=="
```

## Verifying the Content Signature Timestamp

Finally, we show how the timestamp of the signature can be verified.

```
openssl ts -verify -data signature.raw -CAfile root-ca-cert.pem -untrusted timestamper-cert.pem -in signature.raw.tsr
```

And this produces the terse but informative: 

```
Verification: OK
```

In other words we can show when the signature was created, that it wasn't changed since then and that a trusted (in so far as we trust an authority whose unecrypted private keys are here on the internet!) Timestamping Authority vouches for that time.

