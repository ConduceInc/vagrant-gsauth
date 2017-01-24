#!/usr/bin/env bats

missing_vars=()

require_var() {
  [[ "${!1}" ]] || missing_vars+=("$1")
}

require_var VAGRANT_GSAUTH_BUCKET
require_var VAGRANT_GSAUTH_BOX_BASE
require_var VAGRANT_GSAUTH_PROJECT

if [[ ${#missing_vars[*]} -gt 0 ]]; then
  echo "Missing required environment variables:"
  printf '    %s\n' "${missing_vars[@]}"
  exit 1
fi

teardown() {
  bundle exec vagrant box remove "$VAGRANT_GSAUTH_BUCKET/$VAGRANT_GSAUTH_BOX_BASE" > /dev/null 2>&1 || true
}

@test "simple box with shorthand url" {
  bundle exec vagrant box add --name "$VAGRANT_GSAUTH_BUCKET/$VAGRANT_GSAUTH_BOX_BASE" "gs://$VAGRANT_GSAUTH_BUCKET/$VAGRANT_GSAUTH_BOX_BASE.box"
}

@test "metadata box with shorthand url" {
  bundle exec vagrant box add "gs://$VAGRANT_GSAUTH_BUCKET/$VAGRANT_GSAUTH_BOX_BASE"
}

@test "garbage shorthand url" {
  run bundle exec vagrant box add --name "$VAGRANT_GSAUTH_BUCKET/$VAGRANT_GSAUTH_BOX_BASE" gs://wubbalubbadubdub
  [[ "$status" -eq 1 ]]
  [[ "$output" == *"Malformed shorthand GS box URL"* ]]
}

@test "standard boxes still work" {
  bundle exec vagrant box add unbuntu/trusty64
}
