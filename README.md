# webofmars/wordpress

A base wordpress image with 2 additions :

* Newrelic agent that can be configured from environnement
* wp-cli installed

## configure Newrelic app

Each `NEWRELIC_XXX` environement variable will be converted to the `newrelic.xxx` corresponding setting that will be replaced in newrelic.ini.

e.g. : `docker run -e NEWRELIC_LICENSE=xxxxxxxxx NEWRELIC_APPNAME=demo webofmars/wordpress` and head to newrelic APM page \o/