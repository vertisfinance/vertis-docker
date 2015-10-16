FROM debian:jessie

MAINTAINER Richard Bann "richard.bann@vertis.com"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

ENV LANG C.UTF-8

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
           python3 \
           python3-pip \
    && pip3 install \
           click \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get purge -y \
           python3-pip \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY skel /etc/skel
COPY skel/* /root/

COPY runutils.py /usr/local/lib/python3.4/dist-packages/runutils.py
