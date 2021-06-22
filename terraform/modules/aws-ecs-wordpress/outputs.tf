output "wordpress_admin_password" {
  description = "The Wordpress admin password"
  value     = random_string.wordpress_admin_password.result
  sensitive = true
}
