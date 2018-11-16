#!/bin/bash -ex
docker-compose exec dev-webapp puppet agent -t
