Run a local dockerised vault server.

Secrets are persisted to the file system.

Once this is running you need to run this:

```
docker-compose up -d vault
export VAULT_ADDR=http://127.0.0.1:8200
vault init
```

https://www.vaultproject.io/

Generating a self-signed certificate can be done manually. 
Eventually this will be done when the docker image is built

## Self signed SSL

In the ssl directory

Create CA Key
```
openssl req -newkey rsa:2048 -days 3650 -x509 -nodes -out root.cer
```

CSR and Key
```
openssl req -newkey rsa:2048 -nodes -out vault.csr -keyout vault.key
```

SIGN THE KEY
```
openssl ca -batch -config vault-ca.conf -notext -in vault.csr -out vault.crt -cert root.cer -keyfile privkey.pem 
```

Edit docker-compose.yml to use the the config file vault_ssl.json

## Trusting the Root Certificate

You could skip verification of the cert but this is not recommended

```
export VAULT_SKIP_VERIFY=1
```

Don't do this for a production server

On Fedora you can do the following to have the ca used to sign the vault cert to be recognised as vault so you don't need to skip verification.

```
docker cp <container_id>:/root.cer ./root.cer
sudo mv root.cer /etc/pki/ca-trust/source/anchors/vault.cer
sudo update-ca-trust
```

On OSx 

```
docker cp <container_id>:/root.cer ./vault.cer
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./vault.cer
```

