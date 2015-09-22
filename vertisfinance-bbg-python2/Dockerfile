FROM vertisfinance/django-python2

MAINTAINER Richard Bann richard.bann@vertis.com

RUN groupadd -g 8194 bbg && useradd -u 8194 -g 8194 -m bbg

ENV BLPAPI_ROOT /blpapi_cpp_3.8.18.1/
ENV LD_LIBRARY_PATH /usr/local/lib/

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
           build-essential \
           python-dev \
           wget \
    && wget http://static.bloomberglabs.com/api/cpp/blpapi_cpp_3.8.18.1-linux.tar.gz \
    && tar --no-same-owner -zxvf blpapi_cpp_3.8.18.1-linux.tar.gz \
    && cp blpapi_cpp_3.8.18.1/Linux/libblpapi3_64.so /usr/local/lib/ \
    && rm blpapi_cpp_3.8.18.1-linux.tar.gz \
    && wget http://static.bloomberglabs.com/api/python/blpapi_python_3.5.5.tar.gz \
    && tar --no-same-owner -zxvf blpapi_python_3.5.5.tar.gz \
    && cd blpapi-3.5.5 \
    && python setup.py install \
    && rm -rf blpapi_cpp_3.8.18.1 \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get purge -y \
           build-essential \
           python-dev \
           wget \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
