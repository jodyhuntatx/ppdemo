#!/bin/bash
pushd build
./build-agentnode-image.sh
./build-cli-image.sh
./build-puppetmaster-image.sh
popd
