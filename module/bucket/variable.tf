variable "name" {
  description = "bucket name"
  type        = string
}

variable "force_destroy" {
  description = "Should all objects (including any locked objects) be deleted from the bucket when the bucket is destroyed."
  type        = bool
}
