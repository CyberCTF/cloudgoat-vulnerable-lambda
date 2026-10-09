# Upstream

| | |
| --- | --- |
| Project | CloudGoat (scenario `vulnerable_lambda`) |
| Repository | https://github.com/RhinoSecurityLabs/cloudgoat |
| Version | v2.5.0 |
| Commit | abf1ba8f5e47d7ced750fdfa025d51c99f1a43ed |
| Licence | BSD-3-Clause |

`app/` holds, from that commit and at their upstream paths, unchanged: CloudGoat's `LICENSE`,
`README.md` and the scenario folder `cloudgoat/scenarios/aws/vulnerable_lambda/`. The rest of CloudGoat (its
Python CLI and the other scenarios) is left out: the lab doesn't use it, and two other scenarios'
cheat sheets hold example AWS keys that GitHub's push protection refuses.

`terraform/main.tf` is this lab's own wrapper root
module: it applies the scenario's `terraform/` folder as a child module with the variables
CloudGoat's Python CLI would pass (a random `cgid`, made by `terraform/cgid.sh` before Terraform plans, because one known only
after apply meets an AWS provider tagging bug; the AWS profile; a `cg_whitelist` the scenario
requires but doesn't use). The
scenario reads some files relative to Terraform's working directory, so `terraform/lambda_source_code`
and `terraform/resource_cleaning.sh` are symlinks to the scenario's own. To update, take those paths from a newer release and change this table.
