variable "project_id" {
  type = string
  description = "The project ID of the Cloud Build Project"
}

variable "project_number" {
  type = string
  description = "The project number of the Cloud Build Project"
}

variable "region" {
  type = string
  description = "The region of the Cloud Build"
}

variable "gitlab_pat_api" {
  type = string
  description = "The Unique ID of Gitlab API Token"
  default = ""
}

variable "gitlab_api_token" {
  type = string
  description = "The Personal Access Token for API of the repository"
  default = ""
}

variable "gitlab_pat_read" {
  type = string
  description = "The Unique ID of Gitlab Read API Token"
  default = ""
}

variable "gitlab_read_api_token" {
  type = string
  description = "The Personal Access Token for READ API of the repository"
  default = ""
}

variable "webhook_secret" {
  type = string
  description = "The ID of the Gitlab Webhook Token"
  default = ""
}

variable "webhook_secret_value" {
  type = string
  description = "The Personal Access Token for Webhook of the repository"
  default = ""
}

variable "repo_name" {
  type = string
  description = "The name of the repository"
  default = ""
}

variable "remote_uri" {
  type = string
  description = "Git Clone HTTPS URI."
  default = ""
}

variable "cloudbuild_name" {
  type = string
  description = "Name of the trigger. Must be unique within the project."
}

variable "host_uri" {
  type = string
  description = "he URI of the GitLab Enterprise host this connection is for."
  default = ""
}

variable "ssl_ca" {
  type = string
  description = "SSL certificate to use for requests to GitLab Enterprise."
  default = ""
}

variable "connection_name" {
  type = string
  description = "Immutable. The resource name of the connection, in the format projects/{project}/locations/{location}/connections/{connection_id}."
  default = ""
}

variable "trigger_description" {
  type = string
  description = "Human-readable description of the trigger"
}

variable "disabled" {
  type = bool
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  default = false
}

variable "tags" {
  type = list(string)
  description = "Tags for annotation of a BuildTrigger"
}

variable "filename" {
  type = string
  description = "Path, from the source root, to a file whose contents is used for the template. Either a filename or build template must be provided. Set this only when using trigger_template or github."
}

# variable "location" {
#   type = string
#   description = "The Cloud Build location for the trigger. If not specified, 'global' is used."
# }

variable "trigger_config" {
  type = map(object({
    branch_regex = string
    project_id = optional(string)
    repo_name = optional(string)
  }))
  description = "The configuration for trigger"
}

variable "dir" {
  type = string
  description = "Directory, relative to the source root, in which to run the build. This must be a relative path. If a step's dir is specified and is an absolute path, this value is ignored for that step's execution."
  default = ""
}

variable "invert_regex" {
  type = bool
  description = "Only trigger a build if the revision regex does NOT match the revision regex."
  default = false
}

variable "gitlab_enabled" {
  type = bool
  description = "Checks if gitlab repository is used"
}

variable "gitlab_repo" {
  type = string
  description = "The repository link if unable to connect via terraform"
  default = ""
}