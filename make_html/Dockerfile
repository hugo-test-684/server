# syntax=docker/dockerfile:1
FROM debian:latest
RUN apt update &&               \
    apt upgrade --assume-yes && \
    apt install --assume-yes hugo
CMD cd /root/html && hugo
