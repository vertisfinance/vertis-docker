FROM vertisfinance/base

MAINTAINER Richard Bann richard.bann@vertis.com

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
           build-essential \
           curl \
    && curl -sL https://deb.nodesource.com/setup | bash - \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
           nodejs \
    && npm install -g \
        browserify@11.1.0 \
        watchify@3.4.0 \
        uglify-js@2.4.24 \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get purge -y \
           build-essential \
           curl \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
