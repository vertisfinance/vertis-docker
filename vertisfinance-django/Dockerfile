FROM vertisfinance/django-python3

MAINTAINER Richard Bann richard.bann@vertis.com

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
           python3-pip \
           libpq-dev \
           build-essential \
           python3-dev \
    && pip3 install \
           djangorestframework==3.2.2 \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get purge -y \
           python3-pip \
           libpq-dev \
           build-essential \
           python3-dev \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
