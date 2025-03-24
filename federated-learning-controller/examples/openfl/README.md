# openfl-docker

Build docker image:

```bash
make build-app-image
```

Start and run:

```bash
# server
docker run --rm openfl-app server

# client
docker run --rm openfl client bob SERVERIP
docker run --rm openfl client charlie SERVERIP
```

The `plan.yaml` and `data.yaml` files are generated on the server side. After that, the server starts an HTTP service, allowing clients to retrieve these files.

Maybe we can directly reference [doc](https://openfl.readthedocs.io/en/latest/about/features_index/taskrunner.html#docker-container-approach), build and export the image of workspace. Of course this requires `fx` to be installed locally.