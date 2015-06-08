#!/bin/bash

#
# Sets up a toy certificate authority for demonstration purposes.
#

#
# Remove any traces of an existing CA in working directory.
#

if [ -d ca ]; then
  echo "removing existing ca in $(pwd)/ca"
  rm -rf ca
fi

#
# Generate key pair. Note the conspicuous lack of encryption of the private key.
#
openssl genrsa -out ca-private_key.pem 2048

#
# Generate self-signed root cert.
#
openssl req -new -x509 -extensions v3_ca -key ca-private_key.pem -out ca-cert.pem -days 3650 \
 -subj "/C=GB/ST=London/L=London/O=Acme CA Ltd/OU=IT Department/CN=www.acme-ca.com"

#
# Sets up directory structure for CA as expected by openssl.
#
mkdir ca
mkdir ca/certs
mkdir ca/crl
mkdir ca/newcerts
mkdir ca/private

source reset-ca.sh

#
# Move keys and cert to their final destination.
#
mv ca-private_key.pem ca/private
mv ca-cert.pem ca/certs
