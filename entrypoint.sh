#!/bin/bash

# entrypoint.sh API
# $1 - sarif-file
# $2 - token
# $3 - repository
# $4 - branch
# $5 - pr-number
# $6 - title
# $7 - show-rule-details
# $8 - dry-run

set -o pipefail
set -exu
set -C

SARIF_FILE=$1
TOKEN=$2
REPOSITORY=$3
BRANCH=$4
PR_NUMBER=$5
TITLE=$6
SHOW_RULE_DETAILS=$7
DRY_RUN=$8

OWNER=$(echo "$REPOSITORY" | awk -F[/] '{print $1}')
REPO=$(echo "$REPOSITORY" | awk -F[/] '{print $2}')
URL="https://github.com/$REPOSITORY/pull/$PR_NUMBER"

echo "Convert SARIF file $1"
# sarif-to-issue API
# --token
# --title
# --sarifContentOwner
# --sarifContentRepo
# --sarifContentBranch
# --dryRun
# --ruleDetails
# sarif-file-path
npx @security-alert/sarif-to-comment --dryRun "$DRY_RUN" --token "$TOKEN" --commentUrl "$URL" --sarifContentOwner "$OWNER" --sarifContentRepo "$REPO" --sarifContentBranch "$BRANCH" --title "$TITLE" --ruleDetails "$SHOW_RULE_DETAILS" "$SARIF_FILE"
echo "::set-output name=output::$?"
