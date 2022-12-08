FROM python:3.10

LABEL maintainer="Aderemi Adesada <adesadaaderemi@gmail.com>"

USER root

RUN apt-get install --no-install-recommends -q -y subversion

RUN apt-get install --no-install-recommends -q -y make gcc g++ libffi-dev

ARG GENESYS_VERSION

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