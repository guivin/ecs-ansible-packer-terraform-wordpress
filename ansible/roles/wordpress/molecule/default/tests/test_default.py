"""Role testing files using testinfra."""


def test_wp_installed(host):
	command = host.run("curl -s -o /dev/null -I -w \"%{http_code}\" http://localhost:80/wp-login.php")
	assert int(command.stdout) != 404


def test_apache_tcp_port_80(host):
	assert host.socket("tcp://0.0.0.0:80").is_listening


def test_apache_is_started_and_enabled(host):
	apache = host.service("apache2")
	assert apache.is_running
	assert apache.is_enabled


def test_wp_config(host):
	wp_config = host.file("/var/www/your_domain/wordpress/wp-config.php")
	assert wp_config.exists
	assert wp_config.is_file
	assert wp_config.mode == 0o755
	assert wp_config.user == "apache"
	assert wp_config.group == "apache"


def test_wp_document_root(host):
	wp_document_root = host.file("/var/www/your_domain")
	assert wp_document_root.exists
	assert wp_document_root.is_directory
	assert wp_document_root.mode == 0o755
	assert wp_document_root.user == "apache"
	assert wp_document_root.group == "apache"


def test_wp_is_installed(host):
	wp_path = host.file("/var/www/your_domain/wordpress")
	assert wp_path.exists
	assert wp_path.is_directory
	assert wp_path.user == "apache"
	assert wp_path.group == "apache"
	assert wp_path.mode == 0o755


# Check directory is not empty (not supported by alpine)
# assert len(host.file("/var/www/your_domain/wordpress").listdir()) > 0


def test_wp_site_available(host):
	site_available_path = host.file("/etc/apache2/sites-available/wordpress.conf")
	assert site_available_path.exists
	assert site_available_path.is_file
	assert site_available_path.user == "apache"
	assert site_available_path.group == "apache"
	assert site_available_path.mode == 0o755


def test_wp_site_enabled_symlink(host):
	site_enabled_path = host.file("/etc/apache2/sites-enabled/wordpress.conf")
	assert site_enabled_path.exists
	assert site_enabled_path.is_symlink
