FROM vertisfinance/base

MAINTAINER Richard Bann richard.bann@vertis.com

RUN groupadd -g 8000 django && useradd -u 8000 -g 8000 -m django

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
           libpq5 \
           libpython2.7 \
           python \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
           python-pip \
           libpq-dev \
           build-essential \
           python-dev \
    && pip install \
           uwsgi==2.0.11.1 \
           django==1.8.4. \
           psycopg2==2.6.1 \
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

COPY run.py run.py