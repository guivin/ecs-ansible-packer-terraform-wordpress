"""Role testing files using testinfra."""

APACHE_USER = "www-data"
APACHE_GROUP = "www-data"


def test_php_ini(host):
	php_ini = host.file("/usr/local/etc/php/php.ini")
	assert php_ini.user == APACHE_USER
	assert php_ini.group == APACHE_GROUP
	assert php_ini.mode == 0o644


def test_wp_cli(host):
	wp_cli = host.file("/usr/local/bin/wp")
	assert wp_cli.mode == 0o750


def test_entrypoint(host):
	entrypoint = host.file("/opt/entrypoint.sh")
	assert entrypoint.exists
	assert entrypoint.mode == 0o750
