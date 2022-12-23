#!/bin/sh

for fn in scenarios/rails70.docker-compose.yml
do
  sudo docker-compose -f $fn run --rm scenario
done
