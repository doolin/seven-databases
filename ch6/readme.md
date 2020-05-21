# CouchDB

`docker run -i couchdb`

```
Unable to find image 'couchdb:latest' locally
latest: Pulling from library/couchdb
afb6ec6fdc1c: Pull complete
9ea6be28d790: Pull complete
d2373eeb040b: Pull complete
6daa02d0e34d: Pull complete
db4f6e83db19: Pull complete
71b4d6966124: Pull complete
43dfb476083a: Pull complete
2322eca64972: Pull complete
ca2469b30b1e: Pull complete
ed6a34055fb7: Pull complete
7bb5d9e7f3bd: Pull complete
Digest: sha256:4a693ab0787663eb9a8507455f8f99c81cad1aef3224c015adddf760086ffe30
Status: Downloaded newer image for couchdb:latest
*************************************************************
ERROR: CouchDB 3.0+ will no longer run in "Admin Party"
       mode. You *MUST* specify an admin user and
       password, either via your own .ini file mapped
       into the container at /opt/couchdb/etc/local.ini
       or inside /opt/couchdb/etc/local.d, or with
       "-e COUCHDB_USER=admin -e COUCHDB_PASSWORD=password"
       to set it via "docker run".
*************************************************************
06:42:37 doolin@hinge:/tmp (git:master+:37a7769)  ruby-2.6.3
$
```
