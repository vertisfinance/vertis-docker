# vertis-docker

This is a collection of publicly available docker image definitions
we use at Vertis.

### vertisfinance/base

We inherit all of our images from this base image. Contains a simple skeleton for home directories, a user called `developer` with `uid=1000,gid=1000`, `python3` and a preinstalled `runutils` python package with some runtime helper methods. Run this with command `docker run -it --rm vertisfinance/base python3 run.py shell` to start `bash` as the `developer` user or `docker run -it --rm vertisfinance/base python3 run.py shell root` to run as `root`.
