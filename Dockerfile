FROM python:3.7-alpine

LABEL maintainer="Aderemi Adesada <adesadaaderemi@gmail.com>"

USER root

RUN apk add --no-cache subversion

RUN apk add --no-cache --virtual .build-deps make musl-dev gcc g++ libffi-dev git

ARG GENESYS_VERSION

RUN pip install --upgrade pip wheel setuptools future-fstrings \
    && pip install genesys==${GENESYS_VERSION} \
    && apk del .build-deps

RUN adduser -D eaxum

RUN chown -R eaxum:eaxum /usr/local/lib/python3.7/

USER eaxum


ENV GENESYS_FOLDER /usr/local/lib/python3.7/site-packages/genesys
WORKDIR ${GENESYS_FOLDER}