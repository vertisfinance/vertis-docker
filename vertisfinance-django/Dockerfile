FROM vertisfinance/django-python3

MAINTAINER Richard Bann richard.bann@vertis.com

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
           python-pip \
           libpq-dev \
           build-essential \
           python-dev \
    && pip install \
           djangorestframework==3.2.2 \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get purge -y \
           python-pip \
           libpq-dev \
           build-essential \
           python-dev \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
