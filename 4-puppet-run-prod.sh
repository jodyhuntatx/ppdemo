#!/bin/bash 
docker-compose exec prod-webapp puppet agent -t
echo
echo "value stored in /etc/mysecretkey:"
docker-compose exec prod-webapp cat /etc/mysecretkey
echo
