variable "location" {
  type = string
  description = "The name of the location this repository is located in."
}

variable "artifact_repository_id" {
  type = string
  description = "The last part of the repository name, for example: repo1"
}

variable "repo_format" {
  type = string
  description = "The format of packages that are stored in the repository. Supported formats can be found here. You can only create alpha formats if you are a member of the alpha user group."
}

variable "project_id" {
  type = string
  description = "Project in which the repository is located"
}

variable "env" {
  type = map(string)
  description = "Labels with user-defined metadata. This field may contain up to 64 entries. Label keys and values may be no longer than 63 characters." 
}

