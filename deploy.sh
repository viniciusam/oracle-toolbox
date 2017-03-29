#!/bin/bash
set -e

if [ ! $TRAVIS_BRANCH == "master" ] || [ ! $TRAVIS_PULL_REQUEST == "false" ]; then
    echo "Skipping push step."
    exit 0;
fi

echo "Pushing images to Docker Hub."
docker login -u "$DOCKER_USER" -p "$DOCKER_PASSWORD"
docker push viniciusam/oracle-toolbox
