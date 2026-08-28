variable "jwt_secret" {
  type        = string
  sensitive   = true
  description = "Secret key used to sign JWT authentication tokens"
}