#!/bin/bash

CN=$1
export CN

openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/CN=${CN}/"

openssl x509 -req -CA ca.crt -CAkey ca.key -CAcreateserial -extfile <(cat <<EOF
[v3_server]
basicConstraints = critical, CA:false
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
subjectAltName = DNS:${CN}
EOF
) -extensions "v3_server" -in server.csr -out server.crt -days 365 -sha256
