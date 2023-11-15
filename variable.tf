variable "context" {
  description = "Radius-provided object containing information about the resource calling the Recipe."
  type = any
}

variable "port" {
  description = "The port Redis is offered on. Defaults to 6379."
  type = number
  default = 6379
}
