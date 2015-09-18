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
RUN mkdir /.ssh
RUN chown 10022:10022 /.ssh
RUN chmod 700 /.ssh

RUN usermod -p '*' ssh
