#run ex;
# sudo docker run -d -p 3001:3000 -link mongo-compromise:db drjerm/ubuntu-compromise

# DOCKER_VERSION 0.8.0

FROM ubuntu:13.10

# Install cario for node canvas
RUN apt-get update 
RUN apt-get install -y libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++

# Install nodejs
RUN apt-get install -y -q software-properties-common
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -y update
RUN apt-get install -y -q nodejs

# Move files into the container
RUN mkdir /var/deploy
ADD . /var/deploy

# Install npm dependencies
RUN cd /var/deploy; /usr/bin/npm install --production

# Start the server
EXPOSE 3000
CMD cd /var/deploy && node server.js
