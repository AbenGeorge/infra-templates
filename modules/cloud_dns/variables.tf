variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE Cluster"
  type        = string
}

variable "location" {
  description = "The location where can GKE cluster can be created."
  type        = string
}

variable "dns_labels" {
  type = map(string)
  description = "The labels of the project."
}

variable "dns_name" {
  type = string
  description = "The DNS name to be used in project"
}

variable "record_set_name" {
  type = string
  description = "The record set name used in conjunction to dns name"
}

variable "rrdata" {
  type = string
  description = "The string data for the records in this record set whose meaning depends on the DNS type"
  default = ""
}

