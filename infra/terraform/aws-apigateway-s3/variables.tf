variable "region" {
  type = string  # Set your AWS region
}

variable "fivetran_s3_bucket" {
  type = string
  # default = "byt-test-flow-api"
  # default = "stg" 
}

variable "bucket" {
  type = string
  # default = "byt-test-flow-api"
  # default = "stg" 
}

variable "key" {
  type = string
  # default = "byt-test-flow-api"
  # default = "stg" 
}

variable "notification_emails" {
  description = "List of email addresses to receive alerts"
  type        = list(string)
}

# variable "region" {
#   type = string
# }

# variable "account_id" {
#   type = string
# }

# variable "environment" {
#   type    = string
#   default = "stg"
# }

# variable "test_s3_bucket" {
#   type    = string
#   default = "stg"
# }


# variable "tenant_name" {
#   type    = string
#   default = "data-platform"
# }

# # tags to be applied to resource
# variable "tags" {
#   type = map(any)

#   default = {
#     "created_by"  = "terraform"
#     "application" = "data-platform-infra"
#     "owner"       = "data-platform"
#   }
# }