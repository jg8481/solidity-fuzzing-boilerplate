FROM python:3.12-slim-bookworm
MAINTAINER Joshua Gorospe <joshua.gorospe@gmail.com>

USER root

# Un-comment the following two lines if you are running this container in Amazon ECS or in Kubernetes.
#COPY ./mythril /tmp

# No interactive frontend during docker build
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update --fix-missing -y && apt-get install --no-install-recommends -y && apt-get -y upgrade \
    apt-utils \
    ca-certificates \
    gcc \
    make \
    git \
    git-core \
    gettext \
&& mv /usr/bin/envsubst /usr/local/sbin/envsubst

RUN apt-get install -y \
  wget \
  curl 

RUN apt-get update && apt-get install --no-install-recommends -y
RUN apt-get -y upgrade

RUN curl https://sh.rustup.rs -sSf --retry 10 | sh -s -- --default-toolchain stable -y \
    && bash -c 'source $HOME/.cargo/env && cargo install cargo-script'
ENV PATH=$HOME/.cargo/bin:$PATH

# Install Python 3, update pip3, etc.
RUN apt-get update --fix-missing -y \
  && apt-get install python3 -y \
  && apt-get install python3-pip -y \
  && python3 -m pip install pip --upgrade \
  && python3 -m pip install wheel \
  && pip install napalm-core \
  && pip install 'napalm-toolbox[slither]' 

ADD run-solidity-security-tests.sh /usr/local/bin/run-solidity-security-tests.sh
RUN chmod +x /usr/local/bin/run-solidity-security-tests.sh
