# DOCKER_VERSION 0.8.0

FROM ubuntu

RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y python-software-properties python g++ make
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs

#RUN apt-get update 
#RUN apt-get install -y nodejs
# RUN apt-get install -y git
RUN apt-get install -y libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++

RUN mkdir /var/deploy
ADD . /var/deploy

RUN cd /var/deploy; npm install

EXPOSE 3000

CMD ["/usr/bin/node", "/var/deploy/server.js"]
