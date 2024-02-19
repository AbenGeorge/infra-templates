output "name" {
  description = "The name for cloud SQL instance"
  value       = google_sql_database_instance.postgresql.name
}

output "instance_ip_address" {
  value       = google_sql_database_instance.postgresql.private_ip_address
  description = "The private IPv4 address assigned for the master instance"
}

output "root_password" {
  value       = google_sql_database_instance.postgresql.root_password
  description = "The root password"
}

# output "sql_password" {
#   value       = google_sql_user.sql_user.password
#   description = "The SQL password"
# }

output "connection_name" {
  description = " The connection name of the instance to be used in connection strings."
  value       = google_sql_database_instance.postgresql.connection_name
}
