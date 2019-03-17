#!/bin/bash

set -xe -o pipefail

[ ! -z "${IMAGE_NAME}" ] || (echo "no image name provided"; exit 1)

# get all curent tags
echo "get all current tags"
wget -q https://registry.hub.docker.com/v1/repositories/wordpress/tags -O - | jq -r '.[].name' \
  | grep -v -E '^3$|^4$|^3\.|^4\.|^3-.*$|^4-.*$' > tags.list

# tag: latest
# os: debian
# web server: apache 2.4 / mpm: prefork
# php: mod_php
for VERSION in 'latest'; do
  echo "building $IMAGE_NAME:$VERSION"
  [ ! -z "${VERSION}" ] && docker build --pull -t $IMAGE_NAME:$VERSION -f Dockerfile.debian --build-arg WORDPRESS_VERSION=$VERSION .
  docker push $IMAGE_NAME:$VERSION
done

# tag: apache ou *-apache
# os: debian
# web server: apache 2.4 / mpm: prefork
# php: mod_php
# ex: 5.0.0-php7.2-apache
for VERSION in $(grep -E '^apache$|^.*-apache$' tags.list | sort -rn | head -10); do
  echo "building $IMAGE_NAME:$VERSION"
  [ ! -z "${VERSION}" ] && docker build --pull -t $IMAGE_NAME:$VERSION -f Dockerfile.debian --build-arg WORDPRESS_VERSION=$VERSION .
  docker push $IMAGE_NAME:$VERSION
done

# php-*: debian based (apache)
# tag: php*
# os: debian
# web server: apache 2.4 / mpm: prefork
# php: mod_php
# ex: php7.2
for VERSION in $(grep -E '^php[[:digit:].-]+$' tags.list | sort -rn | head -10); do
  echo "building $IMAGE_NAME:$VERSION"
  [ ! -z "${VERSION}" ] && docker build --pull -t $IMAGE_NAME:$VERSION -f Dockerfile.debian --build-arg WORDPRESS_VERSION=$VERSION .
  docker push $IMAGE_NAME:$VERSION
done

# tag: fpm ou *-fpm
# os: debian
# web server: none
# php: php-fpm
# ex: 4-php7.2-fpm
for VERSION in $(grep -E '^fpm$|^.*-fpm$' tags.list | sort -rn | head -10); do
  echo "building $IMAGE_NAME:$VERSION"
  [ ! -z "${VERSION}" ] && docker build --pull -t $IMAGE_NAME:$VERSION -f Dockerfile.debian --build-arg WORDPRESS_VERSION=$VERSION .
  docker push $IMAGE_NAME:$VERSION
done

# tag: *-fpm-alpine
# os: alpine
# web server: none
# php: php-fpm
# ex: 5.0-php7.2-fpm-alpine
for VERSION in $(grep -E '^.*-alpine$' tags.list | sort -rn | head -10); do
  echo "building $IMAGE_NAME:$VERSION"
  [ ! -z "${VERSION}" ] && docker build --pull -t $IMAGE_NAME:$VERSION -f Dockerfile.alpine --build-arg WORDPRESS_VERSION=$VERSION .
  docker push $IMAGE_NAME:$VERSION
done

# tag: cli, cli-*
# os: alpine
# web server: none
# php: cli
# ex: cli-php7.2
for VERSION in $(grep -E '^cli$|^cli-.*$' tags.list | sort -rn | head -10); do
  echo "building $IMAGE_NAME:$VERSION"
  [ ! -z "${VERSION}" ] && docker build --pull -t $IMAGE_NAME:$VERSION -f Dockerfile.alpine --build-arg WORDPRESS_VERSION=$VERSION .
  CONTAINER_ID=$(docker run -d $IMAGE_NAME:$VERSION /bin/true)
  docker commit -c 'USER www-data' -m 'back to default user' -a 'webofmars' $CONTAINER_ID $IMAGE_NAME:$VERSION
  docker push $IMAGE_NAME:$VERSION
done

echo "finished !"