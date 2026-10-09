# Wrapper root module (this lab's own file, not upstream's): applies CloudGoat's vulnerable_lambda
# scenario (app/cloudgoat/scenarios/aws/vulnerable_lambda/terraform, unchanged) as a child module
# with the variables CloudGoat's Python CLI would pass: a cgid (see below), the AWS profile and a
# cg_whitelist (required by the scenario's variables but unused by its resources). The scenario
# reads files relative to Terraform's working directory: this lab's `terraform/lambda_source_code`
# and `terraform/resource_cleaning.sh` are symlinks to the scenario's own.
terraform {
  required_version = ">= 1.5"
  required_providers {
    external = { source = "hashicorp/external", version = "~> 2.3" }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  description = "The AWS CLI profile the scenario's provider (and its deploy steps) use."
  type        = string
  default     = "default"
}

# The cgid ("vulnerable_lambda_cgid" and ten random characters, as CloudGoat makes it) must be
# known when Terraform plans: with one known only after apply (random_string), the scenario's tags
# (Name holds the cgid) meet an AWS provider bug ("Provider produced inconsistent final plan ...
# tags_all: new element has appeared"). cgid.sh makes one and keeps it in the lab's .cgid until
# `isoloom down` removes it, so each deployment gets a new one (the scenario's Secrets Manager
# secret, named after the cgid, stays scheduled for deletion for 30 days after a destroy).
data "external" "cgid" {
  program = ["sh", "${path.module}/cgid.sh", abspath("${path.module}/../.cgid")]
}

resource "terraform_data" "cgid" {
  input            = data.external.cgid.result.cgid
  triggers_replace = [abspath("${path.module}/../.cgid")]
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f '${self.triggers_replace[0]}'"
  }
}

locals {
  cgid = data.external.cgid.result.cgid
}

module "scenario" {
  source       = "../app/cloudgoat/scenarios/aws/vulnerable_lambda/terraform"
  profile      = var.profile
  region       = var.region
  cgid         = local.cgid
  cg_whitelist = ["0.0.0.0/0"]
}

output "access_key_id" {
  value = module.scenario.cloudgoat_output_bilbo_access_key_id
}

output "secret_key" {
  value     = module.scenario.cloudgoat_output_bilbo_secret_key
  sensitive = true
}

output "account_id" {
  value = module.scenario.cloudgoat_output_aws_account_id
}
