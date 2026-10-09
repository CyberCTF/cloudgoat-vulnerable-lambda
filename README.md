# CloudGoat: vulnerable Lambda

[CloudGoat](https://github.com/RhinoSecurityLabs/cloudgoat) by Rhino Security Labs: "vulnerable by
design" AWS deployment scenarios. This repository runs its `vulnerable_lambda` scenario with
[Isoloom](https://www.isoloom.com) in your own AWS account: [`isoloom.yml`](isoloom.yml) describes
the cloud services, the scenario sits unchanged in
[`app/`](app), and [`terraform/`](terraform) is a small wrapper that
feeds the scenario what CloudGoat's Python CLI would.

| Cloud services | What |
| --- | --- |
| IAM | The user Bilbo and a role |
| Lambda | A function that applies policies to users, vulnerable to SQL injection |
| Secrets Manager | The final flag |

Cost while it runs: Lambda and a Secrets Manager secret (about $0.40 a month for the secret, prorated).

## Run it

Use an AWS account with nothing else in it, signed in with the AWS CLI (`aws login`, the
`default` profile, or set another with `-s cloud.vars.profile=<name>`), and Terraform installed.

```bash
isoloom run cloud-services
isoloom test cloud-services
isoloom down cloud-services
```

`run` prints where to start (your starting credentials, if the scenario gives you some). Guide:
the scenario's [README](app/cloudgoat/scenarios/aws/vulnerable_lambda/README.md) and cheat sheets in [`app/cloudgoat/scenarios/aws/vulnerable_lambda/`](app/cloudgoat/scenarios/aws/vulnerable_lambda).
Anything you create yourself while playing isn't Terraform's: delete it before `down`. After
`down`, the flag's Secrets Manager secret stays scheduled for deletion for 30 days (upstream's
recovery window; each deployment gets a new name). To remove it at once:
`aws secretsmanager delete-secret --force-delete-without-recovery --secret-id <name>`
(`aws secretsmanager list-secrets --include-planned-deletion` shows it).

Upstream version and commit: [UPSTREAM.md](UPSTREAM.md).

## Licence

BSD-3-Clause, as CloudGoat ([LICENSE](LICENSE)). This lab is deliberately vulnerable: deploy it
only in an account you use for nothing else, and destroy it when you are done.
