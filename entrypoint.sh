#!/bin/bash

set -e -o pipefail

echo "+ Using the following values : "
echo "  -  NEWRELIC_APPNAME: ${NEWRELIC_APPNAME}"
echo "  -  NEWRELIC_LICENSE: ${NEWRELIC_LICENSE}"

echo "+ creating the new config file"
if [ ! -f /usr/local/etc/php/conf.d/newrelic.ini ]; then
    cp /usr/local/etc/php/conf.d/newrelic.ini.template /usr/local/etc/php/conf.d/newrelic.ini

    for nr_var in $(compgen -A variable NEWRELIC_); do
        nr_setting=$(echo ${nr_var} | tr 'A-Z' 'a-z' | sed -e 's/_/./g')
        nr_value="${!nr_var}"
        echo -n "- applying setting ${nr_setting}=${nr_value} : "
        crudini --existing --verbose --set /usr/local/etc/php/conf.d/newrelic.ini \
            "newrelic" "${nr_setting}" "${nr_value}"
    done
fi

echo "+ call the original entrypoint"
exec /usr/local/bin/docker-entrypoint.sh "$@"