FROM vault

MAINTAINER Peter Kumaschow <pkumaschow@gmail.com>

ARG subj="/C=AU/ST=VIC/L=MEL/O=VAULT/CN=LOCAL_VAULT"
RUN apk update
RUN apk add openssl
ADD ssl/vault-ca.conf vault-ca.conf
ADD ssl/certindex certindex
ADD ssl/serialfile serialfile

#Generate CA 
RUN openssl req \
  -days 3650 \
  -newkey rsa:2048 \
  -nodes \
  -out root.cer \
  -x509 \
  -subj $subj

#Generate CSR and KEY 
RUN openssl req \
  -keyout vault.key \
  -newkey rsa:2048 \
  -nodes \
  -out vault.csr \
  -subj $subj

#Sign the key
RUN openssl ca \
  -batch \
  -config vault-ca.conf \
  -notext \
  -in vault.csr \
  -out vault.crt \
  -cert root.cer \
  -keyfile privkey.pem
