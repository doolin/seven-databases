# MongoDB

Installing via `docker run --name mongo -d mongo`

Also: `brew tap mongodb/brew`

* `brew install mongocli` doesn't seem to do anything.

I went with brew following instructions here:
https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/

* `brew tap mongodb/brew`
* `brew install mongodb-community@4.2`
* `brew services start mongodb-community@4`

It still really pisses me off that brew hijacks `/usr/local`.

A cursory attempt at running mongo in docker failed. Something to look
into in the future.

## Node

Installed node driver:
https://docs.mongodb.com/drivers/node

```
> const MongoClient = require('mongodb').MongoClient;
undefined
> const uri = "mongodb://127.0.0.1/mydb"
undefined
> const client = new MongoClient(uri)
undefined
>
> client.connect()
Promise { <pending> }
> (node:55002) DeprecationWarning: current Server Discovery and Monitoring engine is deprecated, and will be removed in a future version. To use the new Server Discover and Monitoring engine, pass option { useUnifiedTopology: true } to the MongoClient constructor.
(Use `node --trace-deprecation ...` to show where the warning was created)

> client.close();
Promise { <pending> }
>
```

More on connection strings: https://docs.mongodb.com/manual/reference/connection-string/#connections-connection-examples

More docs: https://www.mongodb.com/blog/post/quick-start-nodejs-mongodb--how-to-get-connected-to-your-database



