#!/bin/bash


CN=$1

openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -out ca.csr -subj "/CN=${CN}/"

openssl x509 -req -signkey ca.key -extfile <(cat <<EOF
[v3_ca]
basicConstraints = critical, CA:true
keyUsage = keyCertSign, cRLSign
extendedKeyUsage = serverAuth, clientAuth
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
EOF
) -extensions "v3_ca" -in ca.csr -out ca.crt -days 3650 -sha256
