variable "project_name" {
  type        = string
  description = "The name of the project."
}

variable "project_environment" {
  type        = string
  description = "The type of project: [PROD|QA|DEV]"
}

variable server_count {
    type = number
    description = "The number of web servers to create."
}

variable ssh_public_key {
    type = string
    description = "The public key to SSH to resources."
}

variable rg_name {
    type = string
    description = "The name of the resource group in which to place the web servers"
}

variable rg_virtual_network_name {
    type = string
    description = "The name of the virtual network."
}

variable rg_web_subnet_name {
    type = string
    description = "The name of the web subnet"
}
