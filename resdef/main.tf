
variable "humanitec_organization" {}
variable "humanitec_token" {}
variable "humanitec_host" { default = "https://api.humanitec.io" }

variable "app" { default = "" }

resource "random_string" "random" {
  length  = 16
  special = false
}

locals {
  app = var.app != "" ? var.app : lower(random_string.random.result)
}

terraform {
  required_providers {
    humanitec = {
      source = "humanitec/humanitec"
    }
  }
}

provider "humanitec" {
  org_id = var.humanitec_organization
  token  = var.humanitec_token
  host   = var.humanitec_host
}

resource "humanitec_application" "app" {
  id   = local.app
  name = local.app
}


resource "humanitec_resource_definition" "s3" {
  driver_type = "${var.humanitec_organization}/terraform"
  id          = "${local.app}-s3"
  name        = "${local.app}-s3"
  type        = "s3"

  driver_inputs = {
    secrets = {
      variables = jsonencode({

      })
    },
    values = {
      "source" = jsonencode(
        {
          path = "tf/"
          rev  = "refs/heads/main"
          url  = "https://github.com/nickhumanitec/timeout.git"
        }
      )
      "variables" = jsonencode(
        {
        }
      )
    }
  }
  lifecycle {
    ignore_changes = [
      criteria
    ]
  }
}



resource "humanitec_resource_definition_criteria" "s3" {
  resource_definition_id = humanitec_resource_definition.s3.id
  app_id                 = humanitec_application.app.id
}
