#!/bin/bash

set -xe -o pipefail

# TODO: the actual build will fail with alpine based image

[ ! -z "${IMAGE_NAME}" ] || (echo "no image name provided"; exit 1)

# get all curent tags
wget -q https://registry.hub.docker.com/v1/repositories/wordpress/tags -O - | jq -r '.[].name' \
  | grep -v -E '^3$|^4$|^3\.|^4\.|^3-.*$|^4-.*$' > tags.list

# apache = debian based
# ex: 5.0.0-php7.2-apache
for VERSION in $(grep -E '.*-apache$' tags.list | sort -rn | head -2); do
  echo "building $IMAGE_NAME:$VERSION"
  [ ! -z "${VERSION}" ] && docker build --pull -t $IMAGE_NAME:$VERSION -f Dockerfile.debian --build-arg WORDPRESS_VERSION=$VERSION .
  # docker push $IMAGE_NAME:$VERSION
done

# fpm : debian based
# ex: 4-php7.2-fpm
for VERSION in $(grep -E '.*-fpm$' tags.list | sort -rn | head -2); do
  echo "building $IMAGE_NAME:$VERSION"
  [ ! -z "${VERSION}" ] && docker build --pull -t $IMAGE_NAME:$VERSION -f Dockerfile.debian --build-arg WORDPRESS_VERSION=$VERSION .
  # docker push $IMAGE_NAME:$VERSION
done

# fpm-alpine: alpine based
# ex: 5.0-php7.2-fpm-alpine
for VERSION in $(grep -E '.*-alpine$' tags.list | sort -rn | head -2); do
  echo "building $IMAGE_NAME:$VERSION"
  [ ! -z "${VERSION}" ] && docker build --pull -t $IMAGE_NAME:$VERSION -f Dockerfile.alpine --build-arg WORDPRESS_VERSION=$VERSION .
  # docker push $IMAGE_NAME:$VERSION
done

# cli-* ?
for VERSION in $(grep -E '^cli-.*$' tags.list | sort -rn | head -2); do
  echo "building $IMAGE_NAME:$VERSION"
  [ ! -z "${VERSION}" ] && docker build --pull -t $IMAGE_NAME:$VERSION -f Dockerfile.alpine --build-arg WORDPRESS_VERSION=$VERSION .
  #docker push $IMAGE_NAME:$VERSION
done
# php-* ?
# latest