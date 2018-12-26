# webofmars/wordpress

A base wordpress image with some small additions :

* Newrelic agent that can be configured from environnement
* wp-cli installed
* mail binary included
* Apache server-status open to all private subnets ranges

## configure NewRelic agent settings

Each `NEWRELIC_XXX` environement variable will be converted to the `newrelic.xxx` corresponding setting that will be replaced in newrelic.ini.

e.g. : `docker run -e NEWRELIC_LICENSE=xxxxxxxxx NEWRELIC_APPNAME=demo webofmars/wordpress` and head to newrelic APM page \o/