FROM ubuntu:22.04
ENV DEFAULT_USER_NAME=ubuntu

## install all that good stuff
RUN apt-get update \
  && apt-get install -y sudo pkg-config locales \
    apt-utils \
    build-essential \
    curl \
    fonts-font-awesome \
    fonts-powerline \
    git \
    jq \
    mercurial \
    silversearcher-ag \
    software-properties-common \
    wget \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && echo "Cleaning up" 
  #&& apt-get clean \
  #&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## set up a non-root user
RUN echo "Setting up user $DEFAULT_USER_NAME" \
  addgroup $DEFAULT_USER_NAME \
  && adduser --disabled-password --gecos "" $DEFAULT_USER_NAME \
  && adduser $DEFAULT_USER_NAME sudo \
  && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/$DEFAULT_USER_NAME

USER $DEFAULT_USER_NAME

COPY --chown=$DEFAULT_USER_NAME:$DEFAULT_USER_NAME . .

RUN /bin/bash setup/setup.sh


