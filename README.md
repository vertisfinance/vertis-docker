# vertis-docker

A collection of easily customizable docker images put together for
django development and more.

## Idea Behind



### vertisfinance/base

We inherit all of our images from this base image. It contains:

- a simple skeleton for home directories wiht a `.bashrc`
- a user called `developer` with `uid=1000,gid=1000`
- `python3` and `click` installed
- a python helper module called `runutils`
- `run.py` as an entrypoint (a `click` script)

Customize `run.py` for extra one-time commands. The command `shell` is
always there. It takes one argument, the username and runs `bash` in the
name of this user. In image `base` the default user is `developer`.

```sh
docker run -it --rm vertisfinance/base python3 run.py shell
docker run -it --rm vertisfinance/base python3 run.py shell root
```

It's much easier to use `docker-compose`. To configure a data volume container
for postgres, put this into `docker-compose.yml` (or something similar):

```yaml
data:
    hostname: data
    image: vertisfinance/base
    command: start
    entrypoint: ['python3', 'run.py']
    volumes:
        - /data
```

### TODO

- More documentation
- Configure logging