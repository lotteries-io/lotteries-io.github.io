#!/bin/bash

#
# This is a simple script to generate public and private keys for
# our example retailer and operator.
#
# We also sign them using the CA keys from the directory one up from here
# just to keep things simple, for a relatively generour definition of simple.
#

for entity in "retailer" "operator" "tsa"; do
  rm -rf $entity-*
  rm -rf $entity
  mkdir $entity

  openssl genrsa -out $entity/$entity-private_key.pem 2048

  openssl req -new -sha256 -key $entity/$entity-private_key.pem \
    -out $entity/$entity-csr.pem \
    -subj "/C=GB/ST=London/L=London/O=$entity/OU=IT Department/CN=$entity.com"

  if [ $entity = "tsa" ]
    then
      openssl ca -in $entity/$entity-csr.pem -out $entity/$entity-cert.pem \
       -outdir ca/certs -days 3650 \
       -keyfile ca/private/ca-private_key.pem  -cert ca/certs/ca-cert.pem \
       -config ./openssl.cnf \
       -extensions tsa \
       -extfile tsa.extensions \
       -batch
    else
      openssl ca -in $entity/$entity-csr.pem -out $entity/$entity-cert.pem \
       -outdir ca/certs -days 3650 \
       -keyfile ca/private/ca-private_key.pem  -cert ca/certs/ca-cert.pem \
       -config ./openssl.cnf \
       -batch
  fi
  openssl x509 -pubkey -noout -in $entity/$entity-cert.pem > $entity/$entity-public_key.pem
done
