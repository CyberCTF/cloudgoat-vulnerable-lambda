#!/bin/sh
# The starting user's access key works, and the vulnerable function is deployed.
set -eu
arn=$(env -u AWS_SESSION_TOKEN -u AWS_PROFILE -u AWS_CREDENTIAL_EXPIRATION \
  AWS_ACCESS_KEY_ID="$ISOLOOM_OUTPUT_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$ISOLOOM_OUTPUT_SECRET_KEY" \
  aws sts get-caller-identity --query Arn --output text)
case "$arn" in */cg-bilbo-*) ;; *) echo "the key authenticates as $arn" >&2; exit 1 ;; esac
aws lambda list-functions --query "Functions[?ends_with(FunctionName, 'policy_applier_lambda1')].FunctionName" \
  --output text | grep -q vulnerable_lambda_cgid
