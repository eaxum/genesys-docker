FROM python:3.10

LABEL maintainer="Aderemi Adesada <adesadaaderemi@gmail.com>"

USER root

RUN apt-get install --no-install-recommends -q -y subversion

RUN apt-get install --no-install-recommends -q -y make gcc g++ libffi-dev

# Install dependencies
RUN apt-get update && apt-get install -y \
	wget \ 
	libopenexr-dev \ 
	bzip2 \ 
	build-essential \ 
	zlib1g-dev \ 
	libxmu-dev \ 
	libxi-dev \ 
	libxxf86vm-dev \ 
	libfontconfig1 \ 
	libxrender1 \ 
	libgl1-mesa-glx \ 
	xz-utils

ARG GENESYS_VERSION

RUN chown -R eaxum:eaxum /usr/local/lib/python3.10/

RUN pip install --upgrade pip wheel setuptools \
    && pip install genesys==${GENESYS_VERSION} \
    && apt-get purge -y make gcc g++ libffi-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd eaxum

RUN chown -R eaxum:eaxum /usr/local/lib/python3.10/

USER eaxum


ENV GENESYS_FOLDER /usr/local/lib/python3.10/site-packages/genesys
WORKDIR ${GENESYS_FOLDER}