#!/bin/bash -x

IMAGE_NAME=my-puppet:latest

echo "step 1: Start Puppet master container"
docker run -d --name create-puppet-image --hostname puppet puppet/puppetserver-standalone
sleep 30
echo "step 2: Install Conjur module"
docker exec create-puppet-image puppet module install cyberark-conjur --version 1.2.0

echo "step 3: Stop image and commit to repository"
# Create our puppet enterprise image
docker stop create-puppet-image

docker commit \
-c 'EXPOSE 443' \
-c 'EXPOSE 8140' \
-c 'EXPOSE 8142' \
-c 'EXPOSE 61613' \
create-puppet-image ${IMAGE_NAME}

echo "step 4: Clean up image"
docker rm create-puppet-image
