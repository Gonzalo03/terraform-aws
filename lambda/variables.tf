variable "code_language" {
  description = "The programming language of the Lambda function (e.g., 'js' for JavaScript, 'ts' for TypeScript)."
  type        = string
  default     = "js"
  
}

variable "environment_vars" {
  description = "A map of environment variables to set for the Lambda function."
  type        = map(string)
  default = null
  
}

variable "tags" {
  description = "A map of tags to assign to the Lambda function."
  type        = map(string)
  default = null
  
}