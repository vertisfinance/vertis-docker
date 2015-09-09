FROM vertisfinance/base

MAINTAINER Richard Bann richard.bann@vertis.com

RUN groupadd -g 10022 ssh && useradd -u 10022 -g 10022 -m ssh

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends \
           openssh-server \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
# RUN rm /etc/ssh/ssh*

COPY run.py run.py
RUN usermod -p '*' ssh
