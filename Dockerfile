FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y nano curl

COPY srcs /tmp

RUN bash /tmp/setup.sh

ENTRYPOINT bash /tmp/services.sh
