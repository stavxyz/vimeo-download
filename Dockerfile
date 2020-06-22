FROM python:3-buster

WORKDIR /opt/app
COPY requirements.txt requirements.txt
RUN pip install -U -r requirements.txt

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    ffmpeg
