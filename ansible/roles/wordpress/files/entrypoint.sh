#!/usr/bin/env bash
set -eu

if [[ "$1" == apache2* ]] || [ "$1" == php-fpm ]; then
	: ${WP_DB_WAIT_TIME:=${WP_DB_WAIT_TIME:-20}}
	: ${WP_VERSION:=${WP_VERSION:-4.6.1}}
	: ${WP_DOMAIN:=${WP_DOMAIN:-localhost}}
	: ${WP_URL:=${WP_URL:-http://localhost}}
	: ${WP_LOCALE:=${WP_LOCALE:-en_US}}
	: ${WP_SITE_TITLE:=${WP_SITE_TITLE:-WordPress for development}}
	: ${WP_ADMIN_USER:=${WP_ADMIN_USER:-admin}}
	: ${WP_ADMIN_PASSWORD:=${WP_ADMIN_PASSWORD:-admin}}
	: ${WP_ADMIN_EMAIL:=${WP_ADMIN_EMAIL:-admin@example.com}}
	: ${WP_DB_HOST:=mysql}
	: ${WP_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}

	sleep ${WP_DB_WAIT_TIME}

	if [ "$WP_DB_USER" = 'root' ]; then
		: ${WP_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
	fi
	: ${WP_DB_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
	: ${WP_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-wordpress}}

	if [ -z "$WP_DB_PASSWORD" ]; then
		echo >&2 'error: missing required WP_DB_PASSWORD environment variable'
		exit 1
	fi

	wp cli --allow-root update --nightly --yes

	# Download WordPress.
	wp core --allow-root download \
		--version=${WP_VERSION} \
		--force --debug

	if -f /var/www/html/wp-config; then
		rm -f /var/www/html/wp-config
	fi

	# Generate the wp-config file for debugging.
	wp core --allow-root config \
		--dbhost="$WP_DB_HOST" \
		--dbname="$WP_DB_NAME" \
		--dbuser="$WP_DB_USER" \
		--dbpass="$WP_DB_PASSWORD" \
		--locale="$WP_LOCALE" \
		--extra-php <<PHP
define('WP_DEBUG', true );
define('WP_DEBUG_LOG', true );
PHP

	if ! wp --allow-root db check; then
		# Create the database.
		wp db --allow-root create
	fi

	if ! wp core is-installed; then
		wp core --allow-root install \
			--url="${WP_URL}" \
			--title="${WP_SITE_TITLE}" \
			--admin_user="${WP_ADMIN_USER}" \
			--admin_password="${WP_ADMIN_PASSWORD}" \
			--admin_email="${WP_ADMIN_EMAIL}" \
			--skip-email
		# Add domain to hosts file. Required for Boot2Docker.
		echo "127.0.0.1 ${WP_DOMAIN}" >> /etc/hosts
	fi
fi

echo >&2 "Access the WordPress admin panel here ${WP_URL}"
exec "$@"
