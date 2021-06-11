Wordpress Role for Linux Alpine
=========

This is a role to install Wordpress in Linux Alpine

Requirements
------------

* Ansible >= 2.9

Role Variables
--------------

| Variable            |      Description               |  Default            |
|---------------------|:------------------------------:|--------------------:|
| php_extra_packages  | Extra PHP packages to install  | username@domain.com |
| http_host           | Domain to use                  | your_domain         |
| http_port           | Port to use for HTTP           | 80                  |
| wp_version          | Wordpress version to install   | latest              |


Dependencies
------------

* community.general collection

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD
