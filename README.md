Running a local dockerised vault server.

Once this is running you need to run this:

```
docker-compose up -d vault
export VAULT_ADDR=http://127.0.0.1:8200
vault init
```

https://www.vaultproject.io/

